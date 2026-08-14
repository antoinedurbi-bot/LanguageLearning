import asyncio

from fastapi.testclient import TestClient

from app.main import app
from app.models.ai_models import AnswerCheckRequest
from app.services import ai_service as ai_service_module
from app.services.ai_service import AiService, normalize, tokenize
from app.services.llm_grader import LlmGradingResult

client = TestClient(app)
service = AiService()


def check(answer: str, expected: str | None):
    return asyncio.run(
        service.check_answer(
            AnswerCheckRequest(
                prompt="Je voudrais un cafe, s'il vous plait.",
                answer=answer,
                target_language="en",
                expected_answer=expected,
            )
        )
    )


class TestNormalize:
    def test_strips_accents_case_and_punctuation(self):
        assert normalize("¿Cuánto cuesta?") == "cuanto cuesta"
        assert normalize("  Hola,   me  llamo Marco. ") == "hola me llamo marco"
        assert normalize("Français") == "francais"

    def test_tokenize_drops_empty_fragments(self):
        assert tokenize("Hello,  world!") == ["hello", "world"]
        assert tokenize("   ") == []


class TestCheckAnswer:
    def test_accepts_an_answer_differing_only_by_accents(self):
        result = check("cuanto cuesta", "¿Cuánto cuesta?")
        assert result.is_correct
        assert result.corrected_answer is None

    def test_rejects_a_different_sentence_and_returns_the_model(self):
        result = check("I want coffee", "I would like a coffee, please.")
        assert not result.is_correct
        assert result.corrected_answer == "I would like a coffee, please."
        assert result.notes

    def test_notes_name_the_missing_words(self):
        result = check(
            "I would like a coffee", "I would like a coffee, please."
        )
        assert not result.is_correct
        assert any("please" in note for note in result.notes)

    def test_notes_flag_a_wrong_word(self):
        result = check("I would like a tea, please.", "I would like a coffee, please.")
        assert any("coffee" in note for note in result.notes)

    def test_notes_are_capped(self):
        result = check("a b c d e f g h", "z y x w v u t s")
        assert len(result.notes) <= 4

    def test_empty_answer_is_not_correct(self):
        result = check("   ", "I would like a coffee, please.")
        assert not result.is_correct
        assert "Aucune reponse" in result.feedback

    def test_without_a_reference_it_says_so_instead_of_guessing(self):
        result = check("anything at all", None)
        assert not result.is_correct
        assert "reference" in result.feedback


class TestLlmIntegration:
    """Verifies AiService defers to the LLM grader when it returns a result,
    and falls back to the deterministic grader when it doesn't — without
    making a real network call in either case."""

    def test_uses_the_llm_verdict_when_available(self, monkeypatch):
        async def fake_grade(**kwargs):
            return LlmGradingResult(
                is_correct=True,
                feedback="Paraphrase correcte, bien joue.",
                corrected_answer=None,
                notes=[],
            )

        monkeypatch.setattr(ai_service_module.llm_grader, "grade", fake_grade)

        # A paraphrase the deterministic grader would reject outright.
        result = check("I'd like a coffee", "I would like a coffee, please.")

        assert result.is_correct
        assert result.feedback == "Paraphrase correcte, bien joue."

    def test_falls_back_to_deterministic_when_llm_returns_none(
        self, monkeypatch
    ):
        async def fake_grade(**kwargs):
            return None

        monkeypatch.setattr(ai_service_module.llm_grader, "grade", fake_grade)

        result = check("I want coffee", "I would like a coffee, please.")

        assert not result.is_correct
        assert result.corrected_answer == "I would like a coffee, please."

    def test_exact_match_short_circuits_before_calling_the_llm(
        self, monkeypatch
    ):
        called = False

        async def fake_grade(**kwargs):
            nonlocal called
            called = True
            return None

        monkeypatch.setattr(ai_service_module.llm_grader, "grade", fake_grade)

        result = check("Hello!", "Hello!")

        assert result.is_correct
        assert not called


class TestRoutes:
    def test_health(self):
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json() == {"status": "ok"}

    def test_check_answer_endpoint(self):
        response = client.post(
            "/api/ai/check-answer",
            json={
                "prompt": "Traduis: bonjour",
                "answer": "hello",
                "target_language": "en",
                "expected_answer": "Hello!",
            },
        )
        assert response.status_code == 200
        body = response.json()
        assert body["is_correct"] is True
        assert body["notes"] == []

    def test_check_answer_endpoint_reports_differences(self):
        response = client.post(
            "/api/ai/check-answer",
            json={
                "prompt": "Traduis: bonjour tout le monde",
                "answer": "hello world",
                "target_language": "en",
                "expected_answer": "Hello everyone!",
            },
        )
        assert response.status_code == 200
        body = response.json()
        assert body["is_correct"] is False
        assert body["corrected_answer"] == "Hello everyone!"
        assert body["notes"]

    def test_expected_answer_is_optional_in_the_schema(self):
        response = client.post(
            "/api/ai/check-answer",
            json={
                "prompt": "Traduis: bonjour",
                "answer": "hello",
                "target_language": "en",
            },
        )
        assert response.status_code == 200
