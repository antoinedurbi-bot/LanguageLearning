# Deploying the backend

The API is a plain FastAPI/ASGI app (`app.main:app`) with no database, so any
platform that can run `uvicorn app.main:app` or build the included
`Dockerfile` works. Four paths are prepared below; pick whichever gives you
the least friction. All of them need the same environment variable(s):

| Variable | Required | Notes |
|---|---|---|
| `GROQ_API_KEY` | Yes, once LLM grading is wired up | Get it from https://console.groq.com/keys. **Never** commit it — set it in the platform's dashboard/secret store only. |
| `GROQ_MODEL` | No | Defaults are handled in code; set this to override the model (e.g. `llama-3.3-70b-versatile`). |

Today the code in `app/services/ai_service.py` is a deterministic stub and
doesn't read `GROQ_API_KEY` yet, so deploys will work with it unset — the
variable is documented here so it's one click away when the LLM integration
lands.

## Option A — Vercel (dashboard)

`vercel.json` now uses Vercel's current zero-config Python runtime (no
`builds`/`routes`, which is the deprecated `@vercel/python` pattern the repo
had before): Vercel auto-detects the `app = FastAPI()` object in
`app/main.py`. The file only pins `maxDuration` for the function.

1. Import the repo in the Vercel dashboard, set **Root Directory** to `backend`.
2. Framework preset: FastAPI (auto-detected).
3. Project Settings -> Environment Variables -> add `GROQ_API_KEY` (and
   `GROQ_MODEL` if you want a non-default model).
4. Deploy.

## Option B — Render.com (`render.yaml` blueprint)

1. Push this repo to GitHub (already required for Vercel too).
2. In the Render dashboard: **New +** -> **Blueprint**, point it at the repo.
   Render finds `backend/render.yaml` automatically (`rootDir: backend` is
   set inside it, so you don't need a separate root-directory setting).
3. Render will prompt for `GROQ_API_KEY` because the blueprint marks it
   `sync: false` (i.e. "ask, don't store in git"). Fill it in when prompted,
   or later under the service's **Environment** tab.
4. First deploy runs `pip install -r requirements.txt` then
   `uvicorn app.main:app --host 0.0.0.0 --port $PORT`, with `/health` as the
   health check path.

## Option C — Fly.io (`fly.toml` + `Dockerfile`)

1. Install `flyctl`, `fly auth login`.
2. From `backend/`: `fly launch --no-deploy` (or just `fly apps create
   language-learning-backend` if you want to keep the name in `fly.toml`
   as-is — otherwise edit the `app` field first, names are global on Fly).
3. `fly secrets set GROQ_API_KEY=your-key-here` (and `GROQ_MODEL` if needed).
4. `fly deploy`. It builds the multi-stage `Dockerfile` and exposes
   `/health` as an HTTP health check on port 8000 (`internal_port` in
   `fly.toml`).

## Option D — Any Docker host (Railway, Fly, Cloud Run, a VPS, ...)

The `Dockerfile` is platform-agnostic:

```bash
cd backend
docker build -t language-learning-backend .
docker run -p 8000:8000 -e PORT=8000 -e GROQ_API_KEY=your-key-here language-learning-backend
```

It's a non-root, multi-stage build that reads `PORT` at container start (most
PaaS platforms — Railway, Cloud Run, Heroku-style — inject `PORT`
automatically; it defaults to `8000` if unset).

## Smoke test any deployment

Once deployed, swap in your URL and run:

```bash
BASE_URL="https://your-deployment-url"

# 1. Health check
curl -s "$BASE_URL/health"
# expected: {"status":"ok"}

# 2. Exercise generation
curl -s -X POST "$BASE_URL/api/ai/generate-exercise" \
  -H "Content-Type: application/json" \
  -d '{"native_language":"fr","target_language":"en","level":"A1","topic":"coffee shop"}'

# 3. Answer checking
curl -s -X POST "$BASE_URL/api/ai/check-answer" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Order a coffee politely","answer":"I would like a coffee please","target_language":"en"}'
```

A healthy deploy returns `200` with JSON bodies on all three. If `/health`
works but the `/api/ai/*` calls 404, double-check the platform's root
directory / build root is set to `backend/` (a common Vercel dashboard
misconfiguration is leaving root at the repo root, which resolves
`app/main.py` to the wrong path).
