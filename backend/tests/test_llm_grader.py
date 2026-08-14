import asyncio

import httpx
import pytest

from app.services import llm_grader


class TestParseResponse:
    def test_parses_clean_json(self):
        result = llm_grader._parse_response(
            '{"is_correct": true, "feedback": "Bien joue.", '
            '"corrected_answer": null, "notes": []}'
        )
        assert result is not None
        assert result.is_correct
        assert result.feedback == "Bien joue."
        assert result.corrected_answer is None

    def test_strips_a_markdown_code_fence(self):
        raw = '```json\n{"is_correct": false, "feedback": "Presque.", ' '"corrected_answer": "Hello!", "notes": ["accent manquant"]}\n```'
        result = llm_grader._parse_response(raw)
        assert result is not None
        assert not result.is_correct
        assert result.corrected_answer == "Hello!"
        assert result.notes == ["accent manquant"]

    def test_returns_none_on_invalid_json(self):
        assert llm_grader._parse_response("not json at all") is None

    def test_returns_none_when_is_correct_is_missing(self):
        assert llm_grader._parse_response('{"feedback": "..."}') is None

    def test_caps_notes_at_four(self):
        raw = (
            '{"is_correct": false, "feedback": "x", "corrected_answer": null, '
            '"notes": ["a", "b", "c", "d", "e", "f"]}'
        )
        result = llm_grader._parse_response(raw)
        assert result is not None
        assert len(result.notes) == 4

    def test_tolerates_a_non_list_notes_field(self):
        raw = (
            '{"is_correct": true, "feedback": "x", '
            '"corrected_answer": null, "notes": "oops a string"}'
        )
        result = llm_grader._parse_response(raw)
        assert result is not None
        assert result.notes == []


class TestGradeWithoutApiKey:
    def test_returns_none_when_no_key_is_configured(self, monkeypatch):
        monkeypatch.delenv("OPENROUTER_API_KEY", raising=False)

        result = asyncio.run(
            llm_grader.grade(
                prompt="Traduis: bonjour",
                answer="hello",
                expected_answer="Hello!",
                target_language="en",
            )
        )
        assert result is None


class TestGradeWithMockedHttp:
    """Exercises the real request path with the network call mocked out, so
    no test here makes an actual call to OpenRouter."""

    def _install_fake_client(self, monkeypatch, *, json_body=None, raise_error=None):
        class FakeResponse:
            def raise_for_status(self):
                if raise_error:
                    raise raise_error

            def json(self):
                return json_body

        class FakeAsyncClient:
            def __init__(self, *args, **kwargs):
                pass

            async def __aenter__(self):
                return self

            async def __aexit__(self, *args):
                return False

            async def post(self, *args, **kwargs):
                return FakeResponse()

        monkeypatch.setattr(llm_grader.httpx, "AsyncClient", FakeAsyncClient)

    def test_returns_a_result_on_a_well_formed_response(self, monkeypatch):
        monkeypatch.setenv("OPENROUTER_API_KEY", "test-key")
        self._install_fake_client(
            monkeypatch,
            json_body={
                "choices": [
                    {
                        "message": {
                            "content": (
                                '{"is_correct": true, "feedback": "Ok.", '
                                '"corrected_answer": null, "notes": []}'
                            )
                        }
                    }
                ]
            },
        )

        result = asyncio.run(
            llm_grader.grade(
                prompt="Traduis: bonjour",
                answer="hello",
                expected_answer="Hello!",
                target_language="en",
            )
        )
        assert result is not None
        assert result.is_correct

    def test_returns_none_on_an_unexpected_response_shape(self, monkeypatch):
        monkeypatch.setenv("OPENROUTER_API_KEY", "test-key")
        self._install_fake_client(monkeypatch, json_body={"unexpected": True})

        result = asyncio.run(
            llm_grader.grade(
                prompt="Traduis: bonjour",
                answer="hello",
                expected_answer="Hello!",
                target_language="en",
            )
        )
        assert result is None

    def test_returns_none_on_http_error(self, monkeypatch):
        monkeypatch.setenv("OPENROUTER_API_KEY", "test-key")
        self._install_fake_client(
            monkeypatch,
            json_body={},
            raise_error=httpx.HTTPStatusError(
                "boom", request=None, response=None
            ),
        )

        result = asyncio.run(
            llm_grader.grade(
                prompt="Traduis: bonjour",
                answer="hello",
                expected_answer="Hello!",
                target_language="en",
            )
        )
        assert result is None
