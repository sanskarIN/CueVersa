# Translation completeness report

- Generated: 2026-08-14
- Template locale: English (`app_en.arb`)
- Shipping translation: Hindi (`app_hi.arb`)
- Runtime locale switch: implemented
- Automated key/placeholder completeness: implemented in
  `tool/validate_project.dart`
- Pseudolocalization: validator `--pseudo` output preserves ICU placeholders and
  expands/accent-marks visible text for manual overflow testing
- Latest validator result: passed with 133 matching localized message keys and
  placeholder parity on 2026-08-14

| Locale | Key completeness | Automated generation/widget | Human language review |
|---|---|---|---|
| English | Complete | Passed | Developer-authored; editorial review pending |
| Hindi | Complete | Passed | Machine/developer-assisted draft; professional review pending |

Do not describe Hindi as professionally reviewed until a named review with date
and corrections is recorded. Release QA also needs plurals, numbers, long text,
200% font scale, missing-glyph, and RTL-safe layout inspection even though an
RTL translation is not currently shipped.
