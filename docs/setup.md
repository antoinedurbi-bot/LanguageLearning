# Configuration du projet

## Firebase

1. Cree un projet dans Firebase Console.
2. Active Authentication avec Email/Password.
3. Cree une base Cloud Firestore.
4. Installe FlutterFire CLI puis execute dans `frontend/` :

```bash
flutterfire configure
```

Cela generera `lib/firebase_options.dart`, importe par `main.dart`.

## Backend IA

Dans `backend/` :

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

L'API expose :

- `GET /health`
- `POST /api/ai/generate-exercise`
- `POST /api/ai/check-answer`

## Donnees Firestore proposees

```text
users/{uid}
  displayName, nativeLanguage, targetLanguage, level, streak, createdAt

users/{uid}/progress/{lessonId}
  score, completed, updatedAt

lessons/{lessonId}
  title, language, level, topic, vocabulary, exercises
```
