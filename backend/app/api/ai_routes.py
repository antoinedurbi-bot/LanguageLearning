from fastapi import APIRouter

from app.models.ai_models import (
    AnswerCheckRequest,
    AnswerCheckResponse,
    ChatRequest,
    ChatResponse,
    ExerciseRequest,
    ExerciseResponse,
)
from app.services import llm_chat
from app.services.ai_service import AiService

router = APIRouter()
ai_service = AiService()

# The model only needs recent context to hold a coherent tutoring
# conversation; sending the full history on every turn would grow the
# request (and the bill) without improving replies.
_MAX_HISTORY_TURNS = 12


@router.post("/generate-exercise", response_model=ExerciseResponse)
def generate_exercise(request: ExerciseRequest) -> ExerciseResponse:
    return ai_service.generate_exercise(request)


@router.post("/check-answer", response_model=AnswerCheckResponse)
async def check_answer(request: AnswerCheckRequest) -> AnswerCheckResponse:
    return await ai_service.check_answer(request)


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    trimmed = request.history[-_MAX_HISTORY_TURNS:]
    result = await llm_chat.reply(
        language=request.target_language,
        level=request.level,
        history=[
            llm_chat.ChatMessage(role=turn.role, content=turn.content)
            for turn in trimmed
        ],
    )
    if result is None:
        return ChatResponse(reply=None, available=False)
    return ChatResponse(reply=result.reply, available=True)
