# Learning App

Application d'apprentissage des langues avec :

- Flutter / Dart pour l'application mobile
- Firebase Auth + Cloud Firestore pour les comptes, la progression et les lecons
- Python / FastAPI pour les fonctions IA: generation d'exercices, correction, feedback

## Structure

```text
frontend/   App Flutter
backend/    API Python IA
firebase/   Regles Firestore et index
docs/       Notes de configuration
```

## Demarrage rapide

1. Installe Flutter et lance `flutter pub get` dans `frontend/`.
2. Cree un projet Firebase, active Authentication et Firestore.
3. Dans `frontend/`, lance `flutterfire configure` pour generer `lib/firebase_options.dart`.
4. Dans `backend/`, cree un environnement Python puis installe les dependances avec `pip install -r requirements.txt`.
5. Lance l'API IA avec `uvicorn app.main:app --reload`.

Voir `docs/setup.md` pour les details.
