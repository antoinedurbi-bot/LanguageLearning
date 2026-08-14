"""Correction via an LLM reachable through OpenRouter.

The deterministic grader in `ai_service.py` compares a learner's answer to the
exact reference sentence, which means a perfectly natural paraphrase — "I'd
like a coffee" instead of "I would like a coffee, please" — gets marked wrong.
An LLM can tell the two apart. This module is the optional upgrade: when
`OPENROUTER_API_KEY` is set, `grade` asks a model to judge the answer on
meaning and grammar rather than string equality, and returns `None` on any
failure (missing key, timeout, malformed response) so the caller can fall back
to the deterministic grader without the request ever failing outright.
"""

from __future__ import annotations

import json
import logging
import os

import httpx

logger = logging.getLogger(__name__)

_OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

# Chosen for cost and instruction-following on a narrow, structured grading
# task rather than open-ended chat; override with OPENROUTER_MODEL for a
# different quality/cost trade-off.
_DEFAULT_MODEL = "anthropic/claude-3.5-haiku"

_TIMEOUT_SECONDS = 8.0

_SYSTEM_PROMPT = """Tu es un professeur de langues qui corrige des exercices \
de traduction pour des francophones. On te donne une phrase francaise a \
traduire, la reponse d'un apprenant, et la traduction de reference attendue.

Regles de correction :
- Accepte toute reponse correcte grammaticalement qui rend fidelement le sens, \
meme si elle differe de la reference (synonymes, ordre des mots equivalent, \
contractions comme "I'd" pour "I would").
- Refuse une reponse si elle change le sens, contient une faute de grammaire, \
ou utilise un registre clairement incorrect pour le contexte (ex: trop \
familier pour une situation polie).
- Ignore les differences d'accents, de majuscules et de ponctuation : elles \
ne doivent jamais faire echouer une reponse.
- Sois concis : feedback en une phrase, notes en une ligne chacune, 3 maximum.

Reponds uniquement avec un objet JSON valide, sans texte autour, au format :
{"is_correct": bool, "feedback": "une phrase en francais", \
"corrected_answer": "la meilleure version" ou null si is_correct est vrai, \
"notes": ["point specifique 1", "point specifique 2"]}"""


def _build_user_prompt(
    *,
    prompt: str,
    answer: str,
    expected_answer: str,
    target_language: str,
) -> str:
    return (
        f"Langue cible : {target_language}\n"
        f"Phrase francaise a traduire : {prompt}\n"
        f"Traduction de reference : {expected_answer}\n"
        f"Reponse de l'apprenant : {answer}"
    )


class LlmGradingResult:
    __slots__ = ("is_correct", "feedback", "corrected_answer", "notes")

    def __init__(
        self,
        *,
        is_correct: bool,
        feedback: str,
        corrected_answer: str | None,
        notes: list[str],
    ) -> None:
        self.is_correct = is_correct
        self.feedback = feedback
        self.corrected_answer = corrected_answer
        self.notes = notes


def _parse_response(raw_content: str) -> LlmGradingResult | None:
    """Extracts the JSON payload from the model's message content.

    Models occasionally wrap JSON in a code fence despite instructions not
    to; a light strip handles that without depending on exact formatting.
    """
    text = raw_content.strip()
    if text.startswith("```"):
        text = text.strip("`")
        if text.startswith("json"):
            text = text[4:]
        text = text.strip()

    try:
        data = json.loads(text)
    except json.JSONDecodeError:
        logger.warning("OpenRouter response was not valid JSON: %r", text[:200])
        return None

    if not isinstance(data, dict) or "is_correct" not in data:
        return None

    notes = data.get("notes") or []
    if not isinstance(notes, list):
        notes = []

    return LlmGradingResult(
        is_correct=bool(data["is_correct"]),
        feedback=str(data.get("feedback") or "Pas de retour."),
        corrected_answer=(
            str(data["corrected_answer"])
            if data.get("corrected_answer")
            else None
        ),
        notes=[str(n) for n in notes][:4],
    )


async def grade(
    *,
    prompt: str,
    answer: str,
    expected_answer: str,
    target_language: str,
) -> LlmGradingResult | None:
    """Grades via OpenRouter. Returns None if the LLM path is unavailable or
    fails for any reason — the caller is expected to fall back silently."""
    api_key = os.environ.get("OPENROUTER_API_KEY")
    if not api_key:
        return None

    model = os.environ.get("OPENROUTER_MODEL", _DEFAULT_MODEL)
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    # OpenRouter attributes usage per app when these are set; harmless to omit.
    if referer := os.environ.get("OPENROUTER_HTTP_REFERER"):
        headers["HTTP-Referer"] = referer
    if title := os.environ.get("OPENROUTER_APP_TITLE", "LinguaLab"):
        headers["X-Title"] = title

    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": _SYSTEM_PROMPT},
            {
                "role": "user",
                "content": _build_user_prompt(
                    prompt=prompt,
                    answer=answer,
                    expected_answer=expected_answer,
                    target_language=target_language,
                ),
            },
        ],
        "temperature": 0,
        "max_tokens": 400,
    }

    try:
        async with httpx.AsyncClient(timeout=_TIMEOUT_SECONDS) as client:
            response = await client.post(
                _OPENROUTER_URL, headers=headers, json=payload
            )
            response.raise_for_status()
            body = response.json()
    except (httpx.HTTPError, ValueError) as error:
        logger.warning("OpenRouter grading unavailable: %s", error)
        return None

    try:
        content = body["choices"][0]["message"]["content"]
    except (KeyError, IndexError, TypeError):
        logger.warning("Unexpected OpenRouter response shape: %r", body)
        return None

    return _parse_response(content)
