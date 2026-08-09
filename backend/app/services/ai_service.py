"""Answer grading.

This is a deterministic grader, not a language model. It compares the learner's
sentence to the expected one and reports the specific differences, which is
both cheap and reliable for the translation exercises the app actually asks.
Swapping in an LLM later means replacing `check_answer` alone; the request and
response shapes already carry everything a model-backed version would need.
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

    def check_answer(self, request: AnswerCheckRequest) -> AnswerCheckResponse:
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
