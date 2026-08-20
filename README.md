# LinguaLab

Application d'apprentissage des langues (francais → anglais, espagnol, chinois, turc)
construite autour d'un moteur de repetition espacee et d'un contenu base sur des
phrases plutot que sur des mots isoles.

## La methode

Trois choix pedagogiques structurent toute l'application.

**L'unite d'apprentissage est la phrase, pas le mot.** Un mot isole donne une
etiquette ; une phrase donne le mot, ses collocations, sa grammaire et un contexte
de rappel. Les phrases sont ordonnees par frequence des mots qu'elles contiennent,
et chacune n'introduit qu'un seul element nouveau par rapport a la precedente
(principe du `i+1`).

**Les revisions sont programmees, pas choisies.** Le planificateur
(`lib/data/srs/scheduler.dart`) est une reimplementation compacte de FSRS-4.5 :
il modelise la memoire par trois variables — stabilite, difficulte,
recuperabilite — au lieu de l'unique facteur de facilite de SM-2. Concretement :

- la courbe d'oubli est une loi de puissance, pas une exponentielle ;
- le gain de stabilite depend du moment de la revision : reviser une carte au
  moment ou elle est presque oubliee la renforce bien plus que la reviser fraiche ;
- la difficulte revient vers sa moyenne, ce qui evite l'« ease hell » de SM-2 ou
  quelques echecs precoces condamnent une carte a revenir indefiniment.

Chaque carte revient quand la probabilite de rappel atteint 90 %.

**L'exercice s'adapte au niveau de consolidation.** Une carte monte l'echelle
reconnaissance → ecoute → reconstruction → texte a trou → production libre a
mesure que sa stabilite augmente. Demander la production trop tot ne fabrique que
de l'echec ; ne jamais la demander ne construit jamais la capacite a parler.

## Fonctionnalites

- 4 langues, ~140 phrases redigees et glosees mot a mot
- 17 lecons de grammaire (anglais, espagnol, chinois — turc a venir), une par
  unite, accessibles avant les phrases de l'unite. Le chinois a ses propres
  types de contenu (tons avec contour visuel, decomposition caractere/radical,
  mots classificateurs) plutot que le format explication/exemple des deux
  autres langues
- 5 types d'exercices, audio de prononciation (TTS systeme)
- **Atelier chinois** (onglet 中文, visible uniquement en mandarin) :
  - ordre des traits anime pour 615 caracteres, a partir des vrais trajets de
    traits, avec ecriture au doigt notee trait par trait sur un 田字格
  - entrainement a l'oreille : identifier le ton d'une syllabe, puis des deux
    syllabes d'un mot (les 20 combinaisons de tons)
  - table des ~400 syllabes du mandarin, chaque syllabe ecoutable dans chacun
    de ses tons
  - dictionnaire de 615 caracteres et 1256 mots HSK 1-2 : cle, composition,
    niveau, mots derives, recherche par pinyin sans les tons
- Objectif quotidien, serie, taux de reussite, carte d'activite sur 12 semaines
- Atelier de production libre avec correction : par LLM via Groq si une
  cle est configuree (tolerant les paraphrases), deterministe sinon
- Fonctionne entierement hors ligne et sans compte ; Firebase ne sert qu'a la
  sauvegarde entre appareils
- Themes sombre et clair, `prefers-reduced-motion` respecte, cibles tactiles
  >= 44pt, contraste AA verifie sur les deux themes

## Structure

```text
frontend/
  lib/core/          Design system : tokens, theme, composants peints
  lib/data/srs/      Planificateur FSRS, construction des sessions, correction
  lib/data/hanzi/    Caracteres chinois : parseur SVG, notation des traits
  lib/data/content/  Les cours (un fichier par langue)
  lib/features/      Ecrans (dont features/chinese/ pour l'atelier mandarin)
  assets/data/       Donnees chinoises generees (voir tools/)
backend/             API FastAPI de correction
firebase/            Regles Firestore et index
tools/               Generation des donnees chinoises
```

## Demarrage

```bash
# Application
cd frontend
flutter pub get
flutter run            # ou: flutter build web --release

# Tests (36 tests widget + unitaires)
flutter test
flutter analyze

# API de correction (optionnelle)
cd backend
python -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
python -m pytest
```

L'application demarre sans configuration : sans projet Firebase elle bascule en
stockage local, et sans backend l'atelier corrige localement.

Pour pointer vers une API deployee :

```bash
flutter build web --dart-define=AI_API_BASE_URL=https://api.exemple.com
```

Voir `docs/setup.md` pour Firebase.

## Donnees chinoises

Les trois fichiers de `frontend/assets/data/` sont **generes**, jamais edites a
la main :

```bash
python3 tools/build_hanzi_assets.py
```

Le script combine deux sources ouvertes :

- **Make Me a Hanzi** — pour chaque caractere, le contour de chaque trait dans
  l'ordre d'ecriture et la « mediane » qui parcourt son axe. C'est ce qui rend
  possible une vraie animation : le contour sert de masque, et l'encre est
  revelee en avancant le long de la mediane.
- **complete-hsk-vocabulary** — niveaux HSK 3.0, frequences, pinyin, sens.

Le perimetre est volontairement borne a HSK 1-2 plus tous les caracteres du
cours de l'app : 615 caracteres, environ 1,5 Mo. L'elargir se fait en changeant
`LEVELS` dans le script et en le relancant.

## Notes

- Les polices (Inter, Plus Jakarta Sans) sont embarquees dans `assets/fonts/`
  plutot que telechargees a l'execution : l'application doit fonctionner hors
  ligne des le premier lancement.
- Le contenu des cours est compile dans l'application. La collection Firestore
  `lessons` et son index restent definis pour un chargement distant ulterieur,
  mais ne sont plus lus.
