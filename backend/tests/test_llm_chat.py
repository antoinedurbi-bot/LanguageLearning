import asyncio

import httpx
import pytest

from app.services import llm_chat


def _history(*, user="Hola, como estas?"):
    return [llm_chat.ChatMessage(role="user", content=user)]


class TestReplyWithoutKey:
    def test_returns_none_when_no_key_is_configured(self, monkeypatch):
        monkeypatch.delenv("GROQ_API_KEY", raising=False)

        result = asyncio.run(
            llm_chat.reply(language="espagnol", level="beginner", history=_history())
        )
        assert result is None


class TestReplyWithMockedHttp:
    """Mirrors test_llm_grader.py's approach: mocks the HTTP layer so no test
    here makes a real call to Groq."""

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

        monkeypatch.setattr(llm_chat.httpx, "AsyncClient", FakeAsyncClient)

    def test_returns_the_reply_text_on_success(self, monkeypatch):
        monkeypatch.setenv("GROQ_API_KEY", "test-key")
        self._install_fake_client(
            monkeypatch,
            json_body={
                "choices": [{"message": {"content": "¡Muy bien, gracias!"}}]
            },
        )

        result = asyncio.run(
            llm_chat.reply(language="espagnol", level="beginner", history=_history())
        )
        assert result is not None
        assert result.reply == "¡Muy bien, gracias!"

    def test_returns_none_on_an_empty_reply(self, monkeypatch):
        monkeypatch.setenv("GROQ_API_KEY", "test-key")
        self._install_fake_client(
            monkeypatch,
            json_body={"choices": [{"message": {"content": "   "}}]},
        )

        result = asyncio.run(
            llm_chat.reply(language="espagnol", level="beginner", history=_history())
        )
        assert result is None

    def test_returns_none_on_an_unexpected_response_shape(self, monkeypatch):
        monkeypatch.setenv("GROQ_API_KEY", "test-key")
        self._install_fake_client(monkeypatch, json_body={"unexpected": True})

        result = asyncio.run(
            llm_chat.reply(language="espagnol", level="beginner", history=_history())
        )
        assert result is None

    def test_returns_none_on_http_error(self, monkeypatch):
        monkeypatch.setenv("GROQ_API_KEY", "test-key")
        self._install_fake_client(
            monkeypatch,
            json_body={},
            raise_error=httpx.HTTPStatusError("boom", request=None, response=None),
        )

        result = asyncio.run(
            llm_chat.reply(language="espagnol", level="beginner", history=_history())
        )
        assert result is None

    def test_unknown_level_falls_back_to_the_raw_string(self, monkeypatch):
        # _LEVEL_LABELS only knows three keys; an unrecognised level should
        # not crash the prompt formatting, just pass through unlabelled.
        monkeypatch.setenv("GROQ_API_KEY", "test-key")
        captured = {}

        class FakeResponse:
            def raise_for_status(self):
                pass

            def json(self):
                return {"choices": [{"message": {"content": "ok"}}]}

        class FakeAsyncClient:
            def __init__(self, *args, **kwargs):
                pass

            async def __aenter__(self):
                return self

            async def __aexit__(self, *args):
                return False

            async def post(self, *args, **kwargs):
                captured["json"] = kwargs.get("json")
                return FakeResponse()

        monkeypatch.setattr(llm_chat.httpx, "AsyncClient", FakeAsyncClient)

        result = asyncio.run(
            llm_chat.reply(language="turc", level="mystery", history=_history())
        )
        assert result is not None
        assert "mystery" in captured["json"]["messages"][0]["content"]
