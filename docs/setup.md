# Configuration du projet

L'application fonctionne sans aucune configuration : la progression est stockee
localement et l'atelier corrige hors ligne. Les etapes ci-dessous n'ajoutent que
la sauvegarde entre appareils et la correction serveur.

## Firebase (optionnel)

1. Cree un projet dans la Firebase Console.
2. Active Authentication (Email/Password) et Cloud Firestore.
3. Depuis `frontend/`, execute :

```bash
flutterfire configure
```

Cela genere `lib/firebase_options.dart`. Tant que `projectId` vaut
`demo-learning-app`, l'application ignore Firebase et reste en mode local.

4. Publie les regles et index :

```bash
firebase deploy --only firestore:rules,firestore:indexes
```

### Donnees Firestore

```text
users/{uid}/progress/{languageCode}
  languageCode    string      'en' | 'es' | 'zh' | 'tr'
  states          map         cardId -> { stability, difficulty, due,
                                          lastReview, reps, lapses }
  streak          number      serie en cours
  bestStreak      number      record
  lastStudyDay    string      'yyyy-MM-dd'
  dailyGoal       number      cartes visees par jour
  reviewsPerDay   map         'yyyy-MM-dd' -> nombre de revisions
  totalReviews    number
  correctReviews  number
```

L'historique `reviewsPerDay` est elague au-dela d'un an a chaque sauvegarde.

Le document est ecrit apres chaque revision, en plus du stockage local. Le
stockage local reste la source de verite pendant une session : un echec reseau
degrade la synchronisation, il ne fait jamais perdre une revision.

## Backend IA (optionnel)

Dans `backend/` :

```bash
python -m venv .venv
. .venv/bin/activate          # Windows : .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Endpoints :

- `GET /health`
- `POST /api/ai/generate-exercise`
- `POST /api/ai/check-answer`

`check-answer` accepte un champ `expected_answer` optionnel. Fourni, le service
compare la reponse au modele et renvoie les differences mot a mot dans `notes` ;
absent, il repond qu'il ne peut pas corriger plutot que d'inventer un verdict.

La correction est deterministe (diff normalise, sans accents ni ponctuation).
Pour brancher un modele de langue, il suffit de remplacer `AiService.check_answer`
dans `app/services/ai_service.py` : les schemas de requete et de reponse portent
deja tout ce qu'un modele aurait besoin de recevoir et de renvoyer.

### Pointer l'application vers l'API

```bash
flutter run --dart-define=AI_API_BASE_URL=http://192.168.1.20:8000
```

Sans cette variable, l'application vise `10.0.2.2:8000` sur l'emulateur Android
et `127.0.0.1:8000` ailleurs. Si l'API est injoignable, l'atelier bascule sur la
correction locale et l'indique par un badge « hors ligne ».
