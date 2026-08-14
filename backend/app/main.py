from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Loaded before importing the routers so OPENROUTER_API_KEY (read at call
# time by app.services.llm_grader) is already in the environment when a
# request comes in. A missing .env is not an error: the app runs the same
# way, just without LLM-backed correction.
load_dotenv()

from app.api.ai_routes import router as ai_router  # noqa: E402

app = FastAPI(title="Learning App AI API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(ai_router, prefix="/api/ai", tags=["ai"])


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
