from fastapi import APIRouter

from app.models.ai_models import AnswerCheckRequest, AnswerCheckResponse, ExerciseRequest, ExerciseResponse
from app.services.ai_service import AiService

router = APIRouter()
ai_service = AiService()


@router.post("/generate-exercise", response_model=ExerciseResponse)
def generate_exercise(request: ExerciseRequest) -> ExerciseResponse:
    return ai_service.generate_exercise(request)


@router.post("/check-answer", response_model=AnswerCheckResponse)
def check_answer(request: AnswerCheckRequest) -> AnswerCheckResponse:
    return ai_service.check_answer(request)
