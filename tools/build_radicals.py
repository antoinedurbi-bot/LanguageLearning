#!/usr/bin/env python3
"""Builds the bundled radical-curriculum asset.

Radical *identity* (pinyin, meaning, stroke count) is standard Kangxi-radical
classification data — the same classification every paper dictionary uses —
hand-entered below because it is small, stable, and not worth round-tripping
through a scraper. What is *not* hand-entered is which characters use each
radical: that is computed straight from the already-bundled hanzi.json, so
every example character is guaranteed to exist in the app with real stroke
data, and the radical list itself is scoped to exactly what this app's 615
characters actually use (no radical the learner will never meet, and no
missing one).

Usage (from the repository root):

    python3 tools/build_radicals.py

Writes frontend/assets/data/radicals.json. Generated artifact: edit this
script, never the JSON.
"""

from __future__ import annotations

import json
import os

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HANZI_PATH = os.path.join(REPO_ROOT, "frontend", "assets", "data", "hanzi.json")
OUT_PATH = os.path.join(REPO_ROOT, "frontend", "assets", "data", "radicals.json")

# (pinyin, French meaning, stroke count of the radical form itself).
# Standard Kangxi radical set restricted, at generation time, to the ones the
# HANZI_PATH assert below confirms are actually used by the bundled 615
# characters.
RADICAL_INFO: dict[str, tuple[str, str, int]] = {
    "一": ("yī", "un, trait horizontal", 1),
    "丨": ("gǔn", "trait vertical", 1),
    "丶": ("zhǔ", "point", 1),
    "丿": ("piě", "trait tombant", 1),
    "乙": ("yǐ", "second (repère), trait courbe", 1),
    "乚": ("yǐ", "trait courbe (variante)", 1),
    "亅": ("jué", "crochet", 1),
    "二": ("èr", "deux", 2),
    "亠": ("tóu", "couvercle (tête de 亠)", 2),
    "人": ("rén", "personne", 2),
    "亻": ("rén", "personne (forme laterale)", 2),
    "儿": ("ér", "enfant, jambes humaines", 2),
    "入": ("rù", "entrer", 2),
    "八": ("bā", "huit, diviser", 2),
    "丷": ("bā", "huit (forme superieure de 八)", 2),
    "冂": ("jiōng", "enceinte, périphérie", 2),
    "冖": ("mì", "couverture", 2),
    "冫": ("bīng", "glace", 2),
    "几": ("jǐ", "table basse, presque", 2),
    "凵": ("kǎn", "recipient ouvert", 2),
    "刀": ("dāo", "couteau", 2),
    "刂": ("dāo", "couteau (forme laterale)", 2),
    "力": ("lì", "force", 2),
    "勹": ("bāo", "envelopper", 2),
    "匕": ("bǐ", "cuillere, personne inversee", 2),
    "匸": ("xì", "boite cachee", 2),
    "十": ("shí", "dix", 2),
    "卜": ("bǔ", "divination", 2),
    "卩": ("jié", "sceau, genou plie", 2),
    "厂": ("hǎn", "falaise", 2),
    "厶": ("sī", "prive, personnel", 2),
    "又": ("yòu", "encore, main droite", 2),
    "口": ("kǒu", "bouche", 3),
    "囗": ("wéi", "enceinte, entourer", 3),
    "土": ("tǔ", "terre", 3),
    "士": ("shì", "lettre, gentilhomme", 3),
    "夂": ("zhǐ", "marcher lentement", 3),
    "夊": ("suī", "marcher a pas trainants", 3),
    "夕": ("xī", "soir, crepuscule", 3),
    "大": ("dà", "grand", 3),
    "女": ("nǚ", "femme", 3),
    "子": ("zǐ", "enfant, fils", 3),
    "宀": ("mián", "toit", 3),
    "寸": ("cùn", "pouce (mesure), main a l'echelle", 3),
    "小": ("xiǎo", "petit", 3),
    "尢": ("wāng", "jambe boiteuse", 3),
    "尸": ("shī", "cadavre, corps", 3),
    "山": ("shān", "montagne", 3),
    "工": ("gōng", "travail, ouvrier", 3),
    "己": ("jǐ", "soi-meme", 3),
    "巾": ("jīn", "tissu, serviette", 3),
    "干": ("gān", "sec, tronc", 3),
    "广": ("guǎng", "abri, hangar", 3),
    "廾": ("gǒng", "deux mains jointes", 3),
    "弓": ("gōng", "arc", 3),
    "彡": ("shān", "poils, motif", 3),
    "彳": ("chì", "pas, marche courte", 3),
    "心": ("xīn", "coeur, esprit", 4),
    "忄": ("xīn", "coeur (forme laterale)", 3),
    "戈": ("gē", "hallebarde, arme", 4),
    "户": ("hù", "porte (a un battant)", 4),
    "手": ("shǒu", "main", 4),
    "扌": ("shǒu", "main (forme laterale)", 3),
    "攵": ("pū", "frapper legerement", 4),
    "文": ("wén", "ecriture, culture", 4),
    "斤": ("jīn", "hache, livre chinoise", 4),
    "方": ("fāng", "carre, direction", 4),
    "日": ("rì", "soleil, jour", 4),
    "曰": ("yuē", "dire (litteraire)", 4),
    "月": ("yuè", "lune, mois, chair", 4),
    "木": ("mù", "arbre, bois", 4),
    "欠": ("qiàn", "manquer, bailler", 4),
    "止": ("zhǐ", "arreter, pied", 4),
    "殳": ("shū", "lance courte, action de la main", 4),
    "母": ("mǔ", "mere", 5),
    "比": ("bǐ", "comparer", 4),
    "毛": ("máo", "poil, fourrure", 4),
    "气": ("qì", "vapeur, souffle", 4),
    "水": ("shuǐ", "eau", 4),
    "氵": ("shuǐ", "eau (forme laterale)", 3),
    "氺": ("shuǐ", "eau (variante)", 4),
    "火": ("huǒ", "feu", 4),
    "灬": ("huǒ", "feu (quatre points)", 4),
    "爪": ("zhǎo", "griffe", 4),
    "爫": ("zhǎo", "griffe (forme superieure)", 4),
    "父": ("fù", "pere", 4),
    "片": ("piàn", "planche, tranche", 4),
    "牛": ("niú", "boeuf, bovin", 4),
    "犭": ("quǎn", "chien (forme laterale)", 3),
    "王": ("wáng", "roi, jade (forme de 玉)", 4),
    "瓦": ("wǎ", "tuile, poterie", 5),
    "生": ("shēng", "naitre, vivre", 5),
    "用": ("yòng", "utiliser", 5),
    "田": ("tián", "champ", 5),
    "疒": ("nè", "maladie", 5),
    "白": ("bái", "blanc", 5),
    "目": ("mù", "oeil", 5),
    "矢": ("shǐ", "fleche", 5),
    "石": ("shí", "pierre", 5),
    "示": ("shì", "montrer, esprit, culte", 5),
    "礻": ("shì", "esprit, culte (forme laterale)", 4),
    "禸": ("róu", "trace d'animal", 5),
    "禾": ("hé", "cereale, ble", 5),
    "穴": ("xué", "grotte, trou", 5),
    "立": ("lì", "se tenir debout", 5),
    "米": ("mǐ", "riz", 6),
    "糸": ("mì", "fil de soie fin", 6),
    "纟": ("sī", "fil, textile (forme laterale)", 3),
    "网": ("wǎng", "filet", 6),
    "老": ("lǎo", "vieux, age", 6),
    "耂": ("lǎo", "vieux (forme superieure)", 4),
    "而": ("ér", "et, mais (conjonction), barbe", 6),
    "肉": ("ròu", "viande, chair", 6),
    "自": ("zì", "soi-meme, nez", 6),
    "舌": ("shé", "langue", 6),
    "舟": ("zhōu", "bateau", 6),
    "色": ("sè", "couleur", 6),
    "艹": ("cǎo", "herbe, plante", 3),
    "虫": ("chóng", "insecte, ver", 6),
    "行": ("xíng", "marcher, aller", 6),
    "衣": ("yī", "vetement", 6),
    "西": ("xī", "ouest", 6),
    "覀": ("xī", "ouest (variante)", 6),
    "见": ("jiàn", "voir", 4),
    "角": ("jiǎo", "corne, angle", 7),
    "言": ("yán", "parole, dire", 7),
    "讠": ("yán", "parole (forme laterale)", 2),
    "贝": ("bèi", "coquillage, argent", 4),
    "走": ("zǒu", "marcher, courir", 7),
    "足": ("zú", "pied", 7),
    "身": ("shēn", "corps", 7),
    "车": ("chē", "char, vehicule", 4),
    "辶": ("chuò", "marcher, avancer", 3),
    "酉": ("yǒu", "vase a vin, dixieme branche", 7),
    "里": ("lǐ", "village, li (mesure), interieur", 7),
    "钅": ("jīn", "metal (forme laterale)", 5),
    "长": ("cháng", "long", 4),
    "门": ("mén", "porte (a deux battants)", 3),
    "阝": ("fù/yì", "colline (gauche) / cite (droite)", 3),
    "雨": ("yǔ", "pluie", 8),
    "青": ("qīng", "bleu-vert, jeune", 8),
    "非": ("fēi", "non, negation", 8),
    "面": ("miàn", "visage, surface", 9),
    "革": ("gé", "cuir, reforme", 9),
    "音": ("yīn", "son, musique", 9),
    "页": ("yè", "page, tete", 6),
    "风": ("fēng", "vent", 4),
    "飞": ("fēi", "voler", 3),
    "食": ("shí", "nourriture, manger", 9),
    "饣": ("shí", "nourriture (forme laterale)", 3),
    "马": ("mǎ", "cheval", 3),
    "高": ("gāo", "haut, grand", 10),
    "鱼": ("yú", "poisson", 8),
    "鸟": ("niǎo", "oiseau", 5),
    "麻": ("má", "chanvre", 11),
    "黄": ("huáng", "jaune", 11),
    "黑": ("hēi", "noir", 12),
    "⺀": ("bīng", "glace (variante compacte)", 2),
    "⺊": ("bǔ", "divination (variante)", 2),
    "⺌": ("xiǎo", "petit (variante superieure)", 3),
    "⺮": ("zhú", "bambou (forme superieure)", 6),
    "⺼": ("ròu", "chair, viande (forme laterale de 肉)", 4),
}


def main() -> int:
    with open(HANZI_PATH, encoding="utf-8") as handle:
        hanzi = json.load(handle)["characters"]

    used: dict[str, list[tuple[str, int, int]]] = {}
    for ch, info in hanzi.items():
        radical = info.get("r") or ""
        if not radical:
            continue
        used.setdefault(radical, []).append(
            (ch, info.get("h", 0) or 99, info.get("n", 0) or 99)
        )

    missing_info = sorted(set(used) - set(RADICAL_INFO))
    if missing_info:
        raise SystemExit(f"no metadata for radicals: {' '.join(missing_info)}")
    unused_info = sorted(set(RADICAL_INFO) - set(used))
    if unused_info:
        raise SystemExit(f"metadata for radicals never used: {' '.join(unused_info)}")

    radicals = []
    for radical, entries in used.items():
        pinyin, meaning, strokes = RADICAL_INFO[radical]
        # Easiest, most useful examples first: lower HSK level, then fewer
        # strokes, then a stable alphabetical tiebreak.
        entries.sort(key=lambda e: (e[1], e[2], e[0]))
        radicals.append(
            {
                "r": radical,
                "p": pinyin,
                "m": meaning,
                "n": strokes,
                "count": len(entries),
                "examples": [e[0] for e in entries[:8]],
            }
        )

    # Teaching order: the radicals that unlock the most bundled characters
    # first, ties broken by fewest strokes (an easier radical to recognise
    # and to write).
    radicals.sort(key=lambda r: (-r["count"], r["n"], r["r"]))

    payload = {
        "version": 1,
        "source": "Kangxi radical classification (public-domain dictionary "
        "convention); example characters and counts computed from the "
        "app's own bundled hanzi.json.",
        "radicals": radicals,
    }

    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as out:
        json.dump(payload, out, ensure_ascii=False, separators=(",", ":"))

    print(f"wrote {os.path.relpath(OUT_PATH, REPO_ROOT)} "
          f"({len(radicals)} radicals, {os.path.getsize(OUT_PATH)} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
