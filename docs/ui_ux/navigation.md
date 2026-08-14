# Navigation

Splash immediately replaces itself with Home after the first frame; there is no
artificial delay. Home is the hub for Play, challenges, achievements,
statistics, Settings, About, tutorial, rules, cosmetics, Support, and BMC.

Play opens rule and mode selection. Practice/local play open the table directly;
vs AI requests difficulty first. Android predictive back returns through this
route stack. Reset and destructive data operations require confirmation; normal
back/quit actions do not silently delete stored progress.

External repository, creator, email, and BMC routes use explicit affordances and
leave the app only after a tap. No external route is launched from splash or
gameplay. Future deep links require route allowlisting and invalid-state fallback.
