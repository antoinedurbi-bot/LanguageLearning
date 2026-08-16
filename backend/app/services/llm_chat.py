"""Open-ended tutoring chat, via the same OpenRouter path as grading.

Separate from `llm_grader.py` on purpose: grading is a structured, single-shot
JSON task with a narrow prompt, while chat carries conversation history and a
different system prompt tuned for a tutoring voice rather than a grading
rubric. Sharing the module would have meant one prompt trying to do two jobs.

Same failure contract as grading: any problem (no key, timeout, bad response)
returns `None` rather than raising, so the route can turn that into a clear
"unavailable" response instead of a 500.
"""

from __future__ import annotations

import logging
import os

import httpx

logger = logging.getLogger(__name__)

_OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
_DEFAULT_MODEL = "anthropic/claude-3.5-haiku"
_TIMEOUT_SECONDS = 20.0

# A learner in open chat can drift into asking about anything; the prompt
# keeps replies anchored to the language being studied without refusing to
# ever go off-topic (a rigid refusal is worse UX than a gentle redirect).
_SYSTEM_PROMPT_TEMPLATE = """Tu es un tuteur de {language} pour un francophone \
qui apprend cette langue avec l'app LinguaLab. Niveau approximatif de \
l'apprenant : {level}.

Regles :
- Reponds principalement en {language}, avec une traduction ou reformulation \
francaise entre parentheses quand une phrase risque de ne pas etre comprise. \
Adapte la difficulte au niveau indique.
- Corrige les fautes de l'apprenant quand il ecrit en {language}, brievement \
et sans casser le fil de la conversation : une correction glissee dans la \
reponse, pas un cours a part.
- Reste concis : 2-4 phrases par reponse, sauf si l'apprenant demande une \
explication detaillee.
- Si la question sort completement du sujet de l'apprentissage de la langue, \
reponds quand meme brievement puis ramene la conversation vers la pratique.
- N'invente jamais de regle grammaticale ou de traduction dont tu n'es pas sur \
: dis que tu n'es pas certain plutot que d'affirmer une erreur avec confiance."""

_LEVEL_LABELS = {
    "beginner": "debutant (A1-A2)",
    "intermediate": "intermediaire (B1-B2)",
    "advanced": "avance (C1+)",
}


class ChatMessage:
    __slots__ = ("role", "content")

    def __init__(self, *, role: str, content: str) -> None:
        self.role = role
        self.content = content


class ChatResult:
    __slots__ = ("reply",)

    def __init__(self, *, reply: str) -> None:
        self.reply = reply


async def reply(
    *,
    language: str,
    level: str,
    history: list[ChatMessage],
) -> ChatResult | None:
    """Sends the conversation to OpenRouter and returns the tutor's reply.

    `history` is the full conversation so far, oldest first, ending with the
    learner's latest message — the caller is responsible for trimming it to a
    reasonable length before calling this.
    """
    api_key = os.environ.get("OPENROUTER_API_KEY")
    if not api_key:
        return None

    model = os.environ.get("OPENROUTER_MODEL", _DEFAULT_MODEL)
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    if referer := os.environ.get("OPENROUTER_HTTP_REFERER"):
        headers["HTTP-Referer"] = referer
    if title := os.environ.get("OPENROUTER_APP_TITLE", "LinguaLab"):
        headers["X-Title"] = title

    system_prompt = _SYSTEM_PROMPT_TEMPLATE.format(
        language=language,
        level=_LEVEL_LABELS.get(level, level),
    )

    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": system_prompt},
            *[{"role": m.role, "content": m.content} for m in history],
        ],
        "temperature": 0.6,
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
        logger.warning("OpenRouter chat unavailable: %s", error)
        return None

    try:
        content = body["choices"][0]["message"]["content"]
    except (KeyError, IndexError, TypeError):
        logger.warning("Unexpected OpenRouter chat response shape: %r", body)
        return None

    text = str(content).strip()
    if not text:
        return None
    return ChatResult(reply=text)
