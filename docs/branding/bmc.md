# Buy Me a Coffee experience

Destination: `https://buymeacoffee.com/sanskarIN`.

CueVerse uses original coffee-cup, heart, cue, ball, and project typography
artwork in `assets/branding/bmc_support_card.svg` and its dark counterpart. It
does not copy the Buy Me a Coffee protected logo. “Buy Me a Coffee” appears only
as a service-identifying phrase.

## Placement and behavior

- Prominent on Home, Settings, Support, About, README, and docs landing page.
- Never shown as a popup or overlay in active gameplay.
- Never blocks play, removes ads, grants currency, promises a feature, or
  changes support priority.
- Opens only after an explicit tap with accessible label “Support Sanskar on
  Buy Me a Coffee” and external-link affordance.
- Minimum 48 dp touch behavior, visible focus/pressed states, localized context,
  and graceful localized failure.
- No click tracking or donation-state storage.

Release QA checks light/dark contrast, large text, keyboard/focus where
applicable, TalkBack label, URL destination, offline launcher failure, and that
no game route renders the card.
