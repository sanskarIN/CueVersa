# Design system

CueVerse uses Material 3 as an accessibility/layout foundation with original
game branding.

## Tokens

- Deep navy `#071B2D`: dark surfaces and brand depth.
- Felt green `#007A65`: primary action/table identity.
- Mint `#67E8C4`: dark-theme interactive emphasis.
- Gold `#F7C948`: warm accent; never the only signal.
- Card radius 20 dp; game table radius derives from table size.
- Standard screen inset 16–20 dp and 12 dp card gaps.
- Interactive controls target at least 48×48 dp.

ColorScheme-generated roles, not raw brand colors, drive text/surfaces. High
contrast uses stronger outlines and primary roles. Cards combine icon, title,
subtitle, shape, and state so color never carries critical meaning alone.

Components include CueVerseMark, CreatorWatermark, BmcSupportCard, home action
cards, mode tiles, grouped settings sections, pool table, power slider, spin pad,
and standard confirmation/result dialogs.
