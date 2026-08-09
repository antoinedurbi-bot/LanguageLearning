from pydantic import BaseModel, Field


class ExerciseRequest(BaseModel):
    native_language: str = Field(default="fr", examples=["fr"])
    target_language: str = Field(examples=["en"])
    level: str = Field(default="A1", examples=["A1"])
    topic: str = Field(default="general", examples=["coffee shop"])


class ExerciseResponse(BaseModel):
    prompt: str
    expected_answer: str
    hint: str


class AnswerCheckRequest(BaseModel):
    prompt: str
    answer: str
    target_language: str

    # The sentence the client expects. When present the service can grade
    # precisely instead of guessing; when absent it falls back to heuristics.
    expected_answer: str | None = None


class AnswerCheckResponse(BaseModel):
    is_correct: bool
    feedback: str
    corrected_answer: str | None = None

    # One remark per difference found, so the client can render them as a list.
    notes: list[str] = Field(default_factory=list)
