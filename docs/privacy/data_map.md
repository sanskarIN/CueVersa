# Privacy data map

Current release has no network data flow initiated automatically.

| Data | Source | Storage | Purpose | Leaves device? | Retention/control |
|---|---|---|---|---|---|
| Theme/language/accessibility/control/audio preferences | User settings | SharedPreferences | Personalize UI/gameplay | No | Reset/delete/app uninstall |
| XP, matches, wins, streak, shots, pots | Local gameplay | SharedPreferences | Local progression/statistics | No | Delete/app uninstall |
| Developer unlock/local diagnostics | User action | SharedPreferences or in-memory | Safe debugging | No | Reset/delete/app uninstall |
| Repository/BMC/email action | Explicit tap | External browser/mail app | Open requested destination | URI handled externally | External service policy |

Android backup/device transfer excludes preferences and databases. CueVerse
does not request contacts, camera, microphone, precise location, health,
calendar, SMS, call log, advertising ID, account, or payment data.

## Change gate

Any backend, cloud save, crash reporting, analytics, ads, billing, notifications,
leaderboard, or moderation system must add rows for every field/event, recipient,
purpose, necessity, retention, region, access/deletion control, and security
measure before code is enabled.
