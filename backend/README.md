# Backend Python IA

API FastAPI pour generer des exercices et corriger les reponses.

## Installation

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Endpoints

```http
GET /health
POST /api/ai/generate-exercise
POST /api/ai/check-answer
```

Le service IA est volontairement deterministe au depart. Remplace `app/services/ai_service.py` par un appel LLM quand la cle API est prete.
