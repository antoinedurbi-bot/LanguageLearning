# Frontend Flutter

## Installation

```bash
flutter pub get
flutterfire configure
flutter run
```

## Ecrans inclus

- Authentification Email/Password avec Firebase Auth
- Accueil avec navigation Lecons / Pratique / Profil
- Liste des lecons depuis Cloud Firestore
- Ecran de pratique connecte au backend Python IA

## Note Android emulator

L'URL `http://10.0.2.2:8000` dans `lib/services/ai_service.dart` pointe vers le backend local depuis l'emulateur Android. Pour iOS simulator ou web, utiliser plutot `http://localhost:8000`.
