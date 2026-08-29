from pydantic import BaseModel, Field, field_validator


class ExerciseRequest(BaseModel):
    native_language: str = Field(default="fr", min_length=1, max_length=32, examples=["fr"])
    target_language: str = Field(min_length=1, max_length=32, examples=["en"])
    level: str = Field(default="A1", min_length=1, max_length=16, examples=["A1"])
    topic: str = Field(default="general", min_length=1, max_length=200, examples=["coffee shop"])


class ExerciseResponse(BaseModel):
    prompt: str
    expected_answer: str
    hint: str


class AnswerCheckRequest(BaseModel):
    prompt: str = Field(min_length=1, max_length=2000)
    answer: str = Field(min_length=1, max_length=2000)
    target_language: str = Field(min_length=1, max_length=32)

    # The sentence the client expects. When present the service can grade
    # precisely instead of guessing; when absent it falls back to heuristics.
    expected_answer: str | None = Field(default=None, max_length=2000)


class AnswerCheckResponse(BaseModel):
    is_correct: bool
    feedback: str
    corrected_answer: str | None = None

    # One remark per difference found, so the client can render them as a list.
    notes: list[str] = Field(default_factory=list)


class ChatTurn(BaseModel):
    # "user" or "assistant" — validated below rather than typed as a Literal
    # so a malformed client request gets a clear 422 instead of a silent
    # coercion.
    role: str
    content: str = Field(min_length=1, max_length=4000)

    @field_validator("role")
    @classmethod
    def _role_is_valid(cls, value: str) -> str:
        if value not in ("user", "assistant"):
            raise ValueError('role must be "user" or "assistant"')
        return value


class ChatRequest(BaseModel):
    target_language: str = Field(min_length=1, max_length=32, examples=["espagnol"])
    level: str = Field(default="beginner", min_length=1, max_length=16, examples=["beginner"])

    # Full conversation so far, oldest first, ending with the learner's latest
    # message. Capped generously here; the service trims further before
    # sending to the model.
    history: list[ChatTurn] = Field(max_length=40)

    @field_validator("history")
    @classmethod
    def _history_not_empty(cls, value: list[ChatTurn]) -> list[ChatTurn]:
        if not value:
            raise ValueError("history must contain at least one message")
        if value[-1].role != "user":
            raise ValueError("the last message in history must be from the user")
        return value


class ChatResponse(BaseModel):
    reply: str | None

    # False when the AI backend could not be reached at all (no key,
    # timeout) — distinct from a normal reply, so the client can show a
    # specific "tuteur indisponible" state instead of an empty bubble.
    available: bool
