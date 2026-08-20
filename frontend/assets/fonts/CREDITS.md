# Font credits

Fonts are bundled as static TTF files (rather than fetched at runtime via
`google_fonts`) so the app keeps working offline from first launch. All
families below are Google Fonts, downloaded from `fonts.googleapis.com` /
`fonts.gstatic.com`.

| Family | Files | Role |
| --- | --- | --- |
| Fredoka | Fredoka-500/600/700.ttf | Display, headings, buttons — the "Mimi" identity's rounded, warm face. |
| Nunito Sans | NunitoSans-400/600/700.ttf | Body text. |
| Space Mono | SpaceMono-400/700.ttf | Tags, stats, mono/tabular data. |
| Noto Serif SC | NotoSerifSC-400/700.ttf | Fallback face for Simplified Chinese (Hanzi) text — see below. |
| Noto Serif JP | NotoSerifJP-400/700.ttf | Fallback face for Japanese (Hiragana/Katakana/Kanji) text — see below. |

The first three families are committed unmodified. The two Noto Serif faces
are **subset**: the full families are ~7-15MB each per weight, almost
entirely glyphs this app never uses, so each was reduced with `fonttools`
(`pyftsubset`) to exactly the characters this app's content actually
contains — every Hanzi/Kana/Kanji literal across `lib/data/hanzi/`,
`lib/data/kana/`, `lib/data/content/`, and `assets/data/*.json` — plus ASCII,
CJK punctuation, the full Hiragana/Katakana blocks and CJK fullwidth forms as
headroom for future content. This took each weight from multiple megabytes
down to ~500KB. Coverage was verified programmatically (every character the
app's Chinese/Japanese data files actually use was checked present in the
subsetted font's cmap) before bundling — regenerate rather than hand-edit if
the character inventory changes.

Registered as their own font families (`NotoSerifSC` / `NotoSerifJP`) and
wired in via `fontFamilyFallback` in `core/theme/app_theme.dart`, not swapped
in for Fredoka/Nunito Sans directly: Latin text keeps the Mimi type system,
and CJK glyphs — which Fredoka/Nunito Sans/Space Mono don't contain at all —
fall through to these automatically wherever they appear, on every platform
including Flutter web, which (unlike native) has no OS font fallback of its
own and previously rendered Chinese/Japanese text as empty tofu boxes.

License: [SIL Open Font License 1.1](https://openfontlicense.org/) (OFL) for
every family here, including the Noto Serif SC/JP subsets — the OFL
explicitly permits subsetting. The OFL permits bundling, embedding and
redistribution inside an application, including commercial use, without a
separate license grant, provided the font names are not used to promote a
derivative build.

Source pages:
- https://fonts.google.com/specimen/Fredoka
- https://fonts.google.com/specimen/Nunito+Sans
- https://fonts.google.com/specimen/Space+Mono
- https://fonts.google.com/specimen/Noto+Serif+SC
- https://fonts.google.com/specimen/Noto+Serif+JP
