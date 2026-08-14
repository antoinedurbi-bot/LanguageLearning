"""Answer grading.

Two graders exist. The deterministic one compares the learner's sentence to
the expected one and reports the specific differences: cheap, reliable, and
right whenever the answer matches the reference closely. Its blind spot is a
correct paraphrase — "I'd like a coffee" marked wrong against "I would like a
coffee, please." When `OPENROUTER_API_KEY` is set, `check_answer` asks an LLM
(via `llm_grader`) to judge meaning and grammar first, and only falls back to
the deterministic grader if that call is unavailable or fails — an exact
match is still handled without calling the LLM at all, since there is nothing
for a model to add there.
"""

from __future__ import annotations

import difflib
import re
import unicodedata

from app.models.ai_models import (
    AnswerCheckRequest,
    AnswerCheckResponse,
    ExerciseRequest,
    ExerciseResponse,
)
from app.services import llm_grader

# Punctuation and marks that carry no meaning for grading purposes.
_PUNCTUATION = re.compile(r"[.,!?;:¿¡\"'“”’()\[\]\-–—]")
_WHITESPACE = re.compile(r"\s+")


def strip_accents(text: str) -> str:
    """Removes combining marks, leaving base letters."""
    decomposed = unicodedata.normalize("NFD", text)
    return "".join(ch for ch in decomposed if unicodedata.category(ch) != "Mn")


def normalize(text: str) -> str:
    """Lowercases and drops accents, punctuation and repeated spaces.

    A learner who wrote the right sentence without accents knew the answer;
    marking that wrong teaches nothing.
    """
    lowered = strip_accents(text.lower().strip())
    return _WHITESPACE.sub(" ", _PUNCTUATION.sub(" ", lowered)).strip()


def tokenize(text: str) -> list[str]:
    return [token for token in normalize(text).split(" ") if token]


class AiService:
    def generate_exercise(self, request: ExerciseRequest) -> ExerciseResponse:
        return ExerciseResponse(
            prompt=(
                f"Traduis cette phrase de niveau {request.level} "
                f"sur le theme '{request.topic}' en {request.target_language}."
            ),
            expected_answer="",
            hint="Commence par le sujet, puis le verbe.",
        )

    async def check_answer(self, request: AnswerCheckRequest) -> AnswerCheckResponse:
        answer = request.answer.strip()
        expected = (request.expected_answer or "").strip()

        if not answer:
            return AnswerCheckResponse(
                is_correct=False,
                feedback="Aucune reponse saisie.",
                corrected_answer=expected or None,
            )

        if not expected:
            # Without a reference sentence there is nothing to compare against;
            # say so rather than inventing a verdict.
            return AnswerCheckResponse(
                is_correct=False,
                feedback=(
                    "Impossible de corriger : aucune phrase de reference "
                    "n'a ete fournie pour cet exercice."
                ),
            )

        if normalize(answer) == normalize(expected):
            return AnswerCheckResponse(
                is_correct=True,
                feedback="Exact. La phrase correspond au modele attendu.",
            )

        llm_result = await llm_grader.grade(
            prompt=request.prompt,
            answer=answer,
            expected_answer=expected,
            target_language=request.target_language,
        )
        if llm_result is not None:
            return AnswerCheckResponse(
                is_correct=llm_result.is_correct,
                feedback=llm_result.feedback,
                corrected_answer=llm_result.corrected_answer,
                notes=llm_result.notes,
            )

        return self._check_deterministic(answer, expected)

    def _check_deterministic(
        self, answer: str, expected: str
    ) -> AnswerCheckResponse:
        """Diff-based fallback, used when no LLM grader is configured or
        reachable. Assumes the exact-match case was already ruled out."""
        notes = self._diff_notes(answer, expected)
        ratio = difflib.SequenceMatcher(
            None, normalize(answer), normalize(expected)
        ).ratio()

        if ratio >= 0.85:
            feedback = "Tres proche : il reste un detail a corriger."
        elif ratio >= 0.5:
            feedback = "L'idee y est, mais la formulation s'ecarte du modele."
        else:
            feedback = "La phrase attendue est nettement differente."

        return AnswerCheckResponse(
            is_correct=False,
            feedback=feedback,
            corrected_answer=expected,
            notes=notes,
        )

    def _diff_notes(self, answer: str, expected: str) -> list[str]:
        """Turns a word-level diff into readable remarks."""
        given = tokenize(answer)
        wanted = tokenize(expected)
        notes: list[str] = []

        matcher = difflib.SequenceMatcher(None, given, wanted)
        for tag, i1, i2, j1, j2 in matcher.get_opcodes():
            if tag == "equal":
                continue
            got = " ".join(given[i1:i2])
            want = " ".join(wanted[j1:j2])
            if tag == "replace":
                notes.append(f"'{got}' devrait etre '{want}'.")
            elif tag == "delete":
                notes.append(f"'{got}' est en trop.")
            elif tag == "insert":
                notes.append(f"Il manque '{want}'.")

        # More than a handful of remarks is noise, not feedback.
        return notes[:4]
