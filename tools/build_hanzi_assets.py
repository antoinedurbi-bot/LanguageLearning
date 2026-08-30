#!/usr/bin/env python3
"""Builds the bundled Chinese data assets.

Two upstream datasets are combined:

* **Make Me a Hanzi** (github.com/skishore/makemeahanzi, ARPHIC Public License
  for the derived glyph data, MIT for the code) provides, per character, the
  outline path of every stroke *in writing order* plus a "median" polyline
  running down the spine of each stroke. Together those are what make a real
  stroke-order animation possible: the outline is used as a clip, and the ink
  is revealed by drawing along the median.
* **complete-hsk-vocabulary** (github.com/drkameleon/complete-hsk-vocabulary)
  provides HSK levels, frequency ranks, pinyin and English glosses.

Scope is deliberately bounded to HSK 1-2 plus every character used by the
app's own Mandarin course: that is 615 characters and ~1.4 MB, which is small
enough to bundle and covers everything a beginner actually meets. Widening it
is a matter of changing LEVELS below and re-running.

Usage (from the repository root):

    python3 tools/build_hanzi_assets.py

Writes frontend/assets/data/hanzi.json and frontend/assets/data/hsk_words.json.
Both are generated artifacts: edit this script, never the JSON.
"""

from __future__ import annotations

import json
import os
import re
import sys
import urllib.request

GRAPHICS_URL = (
    "https://raw.githubusercontent.com/skishore/makemeahanzi/master/graphics.txt"
)
DICTIONARY_URL = (
    "https://raw.githubusercontent.com/skishore/makemeahanzi/master/dictionary.txt"
)
HSK_URL = (
    "https://raw.githubusercontent.com/drkameleon/"
    "complete-hsk-vocabulary/main/complete.json"
)

# HSK 3.0 bands to bundle. "new-1"/"new-2" are roughly A1/A2.
LEVELS = {"new-1", "new-2"}

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(REPO_ROOT, "frontend", "assets", "data")
CACHE_DIR = os.path.join(REPO_ROOT, ".cache", "hanzi")

CJK = re.compile(r"[一-鿿]")


def fetch(url: str, filename: str) -> str:
    """Downloads once into .cache/ so re-runs are offline and fast."""
    os.makedirs(CACHE_DIR, exist_ok=True)
    path = os.path.join(CACHE_DIR, filename)
    if not os.path.exists(path):
        print(f"downloading {filename} ...", file=sys.stderr)
        urllib.request.urlopen(url, timeout=300)
        with urllib.request.urlopen(url, timeout=300) as response, open(
            path, "wb"
        ) as out:
            out.write(response.read())
    return path


def course_characters() -> set[str]:
    """Every Han character used by the app's Mandarin course."""
    path = os.path.join(
        REPO_ROOT, "frontend", "lib", "data", "content", "course_zh.dart"
    )
    with open(path, encoding="utf-8") as handle:
        return set(CJK.findall(handle.read()))


# --------------------------------------------------------------------------
# Pinyin and tones
#
# Rather than hand-listing a syllable inventory and inventing example words,
# both are derived from the vocabulary itself: a syllable is in the chart
# because real HSK words use it, and a tone-pair drill item is a real word.
# --------------------------------------------------------------------------

TONE_MARKS = {
    "ā": ("a", 1), "á": ("a", 2), "ǎ": ("a", 3), "à": ("a", 4),
    "ē": ("e", 1), "é": ("e", 2), "ě": ("e", 3), "è": ("e", 4),
    "ī": ("i", 1), "í": ("i", 2), "ǐ": ("i", 3), "ì": ("i", 4),
    "ō": ("o", 1), "ó": ("o", 2), "ǒ": ("o", 3), "ò": ("o", 4),
    "ū": ("u", 1), "ú": ("u", 2), "ǔ": ("u", 3), "ù": ("u", 4),
    "ǖ": ("ü", 1), "ǘ": ("ü", 2), "ǚ": ("ü", 3), "ǜ": ("ü", 4),
    "ń": ("n", 2), "ň": ("n", 3), "ǹ": ("n", 4), "ḿ": ("m", 2),
}

# Longest first, so "zh" wins over "z".
INITIALS = [
    "zh", "ch", "sh", "b", "p", "m", "f", "d", "t", "n", "l",
    "g", "k", "h", "j", "q", "x", "r", "z", "c", "s", "y", "w",
]

# The complete inventory of Mandarin finals. Upstream pinyin is not always
# space-separated between syllables, so "zhǐyǒu" would otherwise be read as a
# single syllable with the impossible final "iyou". Validating against this
# list is what keeps such artifacts out of the chart.
FINALS = {
    "a", "o", "e", "ê", "er",
    "ai", "ei", "ao", "ou",
    "an", "en", "ang", "eng", "ong",
    "i", "ia", "ie", "iao", "iu", "ian", "in", "iang", "ing", "iong",
    "u", "ua", "uo", "uai", "ui", "uan", "un", "uang", "ueng",
    "ü", "üe", "üan", "ün",
    "v", "ve", "van", "vn",
}

# Glosses that make a confusing drill item: they teach nothing about the
# syllable and often are not the word's everyday meaning.
BAD_GLOSS_PREFIXES = (
    "surname", "old variant", "variant of", "abbr", "used in",
)


def split_tone(syllable: str) -> tuple[str, int]:
    """Returns the syllable without its tone mark, and the tone (0 = neutral)."""
    base = []
    tone = 0
    for ch in syllable:
        if ch in TONE_MARKS:
            plain, value = TONE_MARKS[ch]
            base.append(plain)
            tone = value
        else:
            base.append(ch)
    return "".join(base), tone


def split_initial(syllable: str) -> tuple[str, str]:
    """Splits a toneless syllable into initial and final."""
    for initial in INITIALS:
        if syllable.startswith(initial):
            return initial, syllable[len(initial):]
    return "", syllable


def is_valid_syllable(syllable: str) -> bool:
    """True when the string really is one Mandarin syllable."""
    _, final = split_initial(syllable)
    return final in FINALS


def is_usable_gloss(gloss: str) -> bool:
    lowered = gloss.strip().lower()
    return bool(lowered) and not lowered.startswith(BAD_GLOSS_PREFIXES)


def build_pinyin(hsk_entries: list[dict]) -> dict:
    single: dict[tuple[str, int], dict] = {}
    pairs: dict[str, list[dict]] = {}
    syllables: dict[str, set[int]] = {}

    for entry in hsk_entries:
        form = entry["forms"][0]
        raw = form["transcriptions"]["pinyin"]
        parts = [p for p in raw.split(" ") if p]
        word = entry["simplified"]
        gloss = "; ".join(form["meanings"][:2])
        level = None
        for name in entry["level"]:
            if name.startswith("new-"):
                suffix = name.rsplit("-", 1)[1]
                if suffix.isdigit():
                    value = int(suffix)
                    level = value if level is None else min(level, value)

        decoded = [split_tone(p.lower()) for p in parts]
        for base, tone in decoded:
            if is_valid_syllable(base):
                syllables.setdefault(base, set()).add(tone)

        # Single-character words make the cleanest tone-perception items:
        # one syllable, one tone, one meaning.
        if len(word) == 1 and len(decoded) == 1 and decoded[0][1] > 0:
            base, tone = decoded[0]
            key = (base, tone)
            if (
                key not in single
                and level is not None
                and level <= 3
                and is_valid_syllable(base)
                and is_usable_gloss(gloss)
            ):
                single[key] = {
                    "w": word,
                    "p": parts[0].lower(),
                    "s": base,
                    "t": tone,
                    "d": gloss,
                    "l": level,
                }

        # Two-syllable words drive the tone-pair drill, which is where tones
        # actually get hard: isolated tones are easy, tones in sequence are not.
        if (
            len(word) == 2
            and len(decoded) == 2
            and level is not None
            and level <= 2
            and all(is_valid_syllable(b) for b, _ in decoded)
            and is_usable_gloss(gloss)
            # A neutral tone never starts a word, so a leading 0 means the
            # upstream transcription lost a tone mark.
            and decoded[0][1] > 0
        ):
            combo = f"{decoded[0][1]}-{decoded[1][1]}"
            bucket = pairs.setdefault(combo, [])
            if len(bucket) < 6:
                bucket.append(
                    {"w": word, "p": raw, "d": gloss, "l": level}
                )

    chart: dict[str, dict[str, list[int]]] = {}
    for base, tones in syllables.items():
        initial, final = split_initial(base)
        if final not in FINALS:
            continue
        chart.setdefault(initial, {})[final] = sorted(tones)

    return {
        "version": 1,
        "toneExamples": sorted(
            single.values(), key=lambda e: (e["t"], e["l"])
        ),
        "tonePairs": {k: v for k, v in sorted(pairs.items()) if v},
        "chart": chart,
    }


def main() -> int:
    graphics_path = fetch(GRAPHICS_URL, "graphics.txt")
    dictionary_path = fetch(DICTIONARY_URL, "dictionary.txt")
    hsk_path = fetch(HSK_URL, "hsk.json")

    graphics: dict[str, dict] = {}
    with open(graphics_path, encoding="utf-8") as handle:
        for line in handle:
            entry = json.loads(line)
            graphics[entry["character"]] = entry

    meta: dict[str, dict] = {}
    with open(dictionary_path, encoding="utf-8") as handle:
        for line in handle:
            entry = json.loads(line)
            meta[entry["character"]] = entry

    with open(hsk_path, encoding="utf-8") as handle:
        hsk_entries = json.load(handle)

    def band(entry: dict) -> int | None:
        """Numeric HSK band for an entry, or None if outside the bundled set."""
        for level in entry["level"]:
            if level in LEVELS:
                return int(level.rsplit("-", 1)[1])
        return None

    words = []
    char_level: dict[str, int] = {}
    for entry in hsk_entries:
        level = band(entry)
        if level is None:
            continue
        form = entry["forms"][0]
        words.append(
            {
                "w": entry["simplified"],
                "p": form["transcriptions"]["pinyin"],
                "d": "; ".join(form["meanings"][:3]),
                "l": level,
                "f": entry.get("frequency", 0),
            }
        )
        for ch in CJK.findall(entry["simplified"]):
            # A character's level is the earliest level it is needed at.
            if ch not in char_level or level < char_level[ch]:
                char_level[ch] = level

    targets = sorted(set(char_level) | course_characters())
    missing = [ch for ch in targets if ch not in graphics]
    if missing:
        print(
            f"warning: no stroke data for {len(missing)} chars: "
            f"{''.join(missing)}",
            file=sys.stderr,
        )

    characters = {}
    for ch in targets:
        if ch not in graphics:
            continue
        info = meta.get(ch, {})
        strokes = graphics[ch]["strokes"]
        characters[ch] = {
            "p": info.get("pinyin", []),
            "d": info.get("definition") or "",
            "r": info.get("radical", ""),
            "c": info.get("decomposition", ""),
            "n": len(strokes),
            "h": char_level.get(ch, 0),
            "s": strokes,
            "m": graphics[ch]["medians"],
        }

    pinyin_payload = build_pinyin(hsk_entries)

    os.makedirs(OUT_DIR, exist_ok=True)

    hanzi_payload = {
        "version": 1,
        "source": "makemeahanzi (ARPHIC Public License) + complete-hsk-vocabulary",
        "coordinateSystem": {
            # Consumers must apply this transform: the upstream glyph data is
            # in a y-up box, so y has to be flipped before painting.
            "viewBox": 1024,
            "transform": "x' = x, y' = 900 - y",
        },
        "characters": characters,
    }

    words.sort(key=lambda w: (w["l"], w["f"] or 10**9))
    words_payload = {"version": 1, "levels": sorted(LEVELS), "words": words}

    outputs = (
        (os.path.join(OUT_DIR, "hanzi.json"), hanzi_payload),
        (os.path.join(OUT_DIR, "hsk_words.json"), words_payload),
        (os.path.join(OUT_DIR, "pinyin.json"), pinyin_payload),
    )
    for path, payload in outputs:
        with open(path, "w", encoding="utf-8") as out:
            json.dump(payload, out, ensure_ascii=False, separators=(",", ":"))
        print(
            f"wrote {os.path.relpath(path, REPO_ROOT)} "
            f"({os.path.getsize(path) / 1e6:.2f} MB)"
        )

    print(f"characters: {len(characters)}  words: {len(words)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
