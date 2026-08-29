from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Loaded before importing the routers so GROQ_API_KEY (read at call
# time by app.services.llm_grader) is already in the environment when a
# request comes in. A missing .env is not an error: the app runs the same
# way, just without LLM-backed correction.
load_dotenv()

from app.api.ai_routes import router as ai_router  # noqa: E402

app = FastAPI(title="Learning App AI API", version="0.1.0")

# allow_origins=["*"] together with allow_credentials=True is invalid per the
# CORS spec (the wildcard cannot be paired with credentialed requests) and
# most browsers reject or strip the response. This API doesn't use
# cookies/browser credentials, so credentials stay disabled here rather than
# restricting origins, which would break the Flutter web build calling this
# from arbitrary dev/hosting origins. If cookie-based auth is ever added,
# allow_origins must be pinned to an explicit allowlist first.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(ai_router, prefix="/api/ai", tags=["ai"])


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
