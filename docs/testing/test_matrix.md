# Release test matrix

| Category | Automated scenarios | Manual/device scenarios | Gate |
|---|---|---|---|
| Math/physics | vector, head-on, 30°/60°, rail, two-rail, draw/follow/English, jaw, scratch, break, deterministic/frame chunks | visual reference/calibration shots | No failure; tolerances justified |
| Rules | break/open/groups, contact, rail/pocket, scratch, ball in hand, 8 outcomes, 9 lowest/win/respot | complete matches/profiles | No illegal transition |
| AI | normalized bounded input, seeded replay, fallback | six levels, legal shots, stuck/endgames | Never bypass rules/physics |
| Persistence | defaults, clamp, restore/delete, XP/stats | reinstall/upgrade/clear/background | No known data loss |
| Localization | English/Hindi runtime widget | human review, pseudo, long text, plural/number | No missing key/overflow |
| Accessibility | BMC/table semantics, control availability | TalkBack, Switch Access, 200% text, contrast, reduced motion | Critical flows usable |
| Navigation/UI | splash/home/practice route | all routes, dialogs, back, rotation, tablet/foldable | No broken route/overflow |
| Android lifecycle | build automation | cold/warm start, background/resume, kill/restore, low memory | No crash/corruption |
| Performance | deterministic step tests | profile frame trace, thermal/battery, low-end device | Target documented/met |
| Security/privacy | analyzer/CodeQL/config review | merged manifest, traffic/backup/link checks | No critical/high issue |
| Release | debug APK CI | R8 AAB, signed install, Play pre-launch | Checklist complete |

Executed results and environment limits are recorded in `what_changed.md`.
