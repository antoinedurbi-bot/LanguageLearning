from fastapi.testclient import TestClient

from app.api import ai_routes
from app.main import app
from app.services import llm_chat

client = TestClient(app)


class _FakeResult:
    def __init__(self, reply):
        self.reply = reply


class TestChatRoute:
    def test_unavailable_without_a_key(self, monkeypatch):
        monkeypatch.delenv("GROQ_API_KEY", raising=False)

        response = client.post(
            "/api/ai/chat",
            json={
                "target_language": "espagnol",
                "level": "beginner",
                "history": [{"role": "user", "content": "Hola!"}],
            },
        )
        assert response.status_code == 200
        body = response.json()
        assert body["available"] is False
        assert body["reply"] is None

    def test_returns_the_tutor_reply_when_the_llm_answers(self, monkeypatch):
        async def fake_reply(*, language, level, history):
            return _FakeResult("¡Hola! ¿Como estas?")

        monkeypatch.setattr(llm_chat, "reply", fake_reply)
        monkeypatch.setattr(ai_routes.llm_chat, "reply", fake_reply)

        response = client.post(
            "/api/ai/chat",
            json={
                "target_language": "espagnol",
                "level": "beginner",
                "history": [{"role": "user", "content": "Hola!"}],
            },
        )
        assert response.status_code == 200
        body = response.json()
        assert body["available"] is True
        assert body["reply"] == "¡Hola! ¿Como estas?"

    def test_rejects_an_empty_history(self):
        response = client.post(
            "/api/ai/chat",
            json={"target_language": "espagnol", "history": []},
        )
        assert response.status_code == 422

    def test_rejects_history_not_ending_on_the_user(self):
        response = client.post(
            "/api/ai/chat",
            json={
                "target_language": "espagnol",
                "history": [{"role": "assistant", "content": "..."}],
            },
        )
        assert response.status_code == 422

    def test_rejects_an_invalid_role(self):
        response = client.post(
            "/api/ai/chat",
            json={
                "target_language": "espagnol",
                "history": [{"role": "system", "content": "..."}],
            },
        )
        assert response.status_code == 422

    def test_trims_history_to_the_most_recent_turns(self, monkeypatch):
        captured = {}

        async def fake_reply(*, language, level, history):
            captured["length"] = len(history)
            return _FakeResult("ok")

        monkeypatch.setattr(ai_routes.llm_chat, "reply", fake_reply)

        long_history = [
            {"role": "user" if i % 2 == 0 else "assistant", "content": f"msg {i}"}
            for i in range(39)
        ] + [{"role": "user", "content": "last"}]

        response = client.post(
            "/api/ai/chat",
            json={"target_language": "espagnol", "history": long_history},
        )
        assert response.status_code == 200
        assert captured["length"] == ai_routes._MAX_HISTORY_TURNS
