from pydantic import BaseModel, Field


class ExerciseRequest(BaseModel):
    native_language: str = Field(examples=["fr"])
    target_language: str = Field(examples=["en"])
    level: str = Field(examples=["A1"])
    topic: str = Field(examples=["coffee shop"])


class ExerciseResponse(BaseModel):
    prompt: str
    expected_answer: str
    hint: str


class AnswerCheckRequest(BaseModel):
    prompt: str
    answer: str
    target_language: str


class AnswerCheckResponse(BaseModel):
    is_correct: bool
    feedback: str
    corrected_answer: str | None = None
