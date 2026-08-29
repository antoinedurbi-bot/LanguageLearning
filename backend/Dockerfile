# Multi-stage build for the FastAPI backend.
# Stage 1: install dependencies into a self-contained venv.
FROM python:3.12-slim AS builder

WORKDIR /build

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Stage 2: slim runtime image, non-root user.
FROM python:3.12-slim AS runtime

# curl is only needed for the HEALTHCHECK below.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 --gid appuser --shell /bin/false --create-home appuser

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY app ./app

RUN chown -R appuser:appuser /app
USER appuser

# Most PaaS platforms (Render, Fly.io, Railway, Heroku, ...) inject PORT at
# runtime; default to 8000 for local `docker run`.
ENV PORT=8000
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f "http://localhost:${PORT}/health" || exit 1

# Shell form so ${PORT} is expanded at container start, not at build time.
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
