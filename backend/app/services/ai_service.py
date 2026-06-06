from app.models.ai_models import AnswerCheckRequest, AnswerCheckResponse, ExerciseRequest, ExerciseResponse


class AiService:
    """Deterministic starter service; replace internals with an LLM provider later."""

    def generate_exercise(self, request: ExerciseRequest) -> ExerciseResponse:
        return ExerciseResponse(
            prompt=f"Translate this {request.level} sentence about {request.topic} into {request.target_language}: Bonjour, je voudrais commander.",
            expected_answer="Hello, I would like to order.",
            hint="Start with a greeting, then use 'I would like...'.",
        )

    def check_answer(self, request: AnswerCheckRequest) -> AnswerCheckResponse:
        normalized = request.answer.strip().lower().replace(".", "")
        accepted = {
            "i would like a coffee please",
            "i'd like a coffee please",
            "i would like one coffee please",
        }

        if normalized in accepted:
            return AnswerCheckResponse(
                is_correct=True,
                feedback="Tres bien. La phrase est naturelle et polie.",
                corrected_answer=None,
            )

        return AnswerCheckResponse(
            is_correct=False,
            feedback="Bonne tentative. Une reponse naturelle serait: 'I would like a coffee, please.'",
            corrected_answer="I would like a coffee, please.",
        )
