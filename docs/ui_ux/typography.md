# Typography

CueVerse uses platform-provided Material typography to avoid unlicensed font
bundles and improve script coverage. Display names use heavy weight and slightly
tight tracking; headings use bold weights; body and labels retain default
readable metrics.

Text must wrap naturally, honor Android font scale, avoid all-caps paragraphs,
and never be painted into fixed-height UI except ball numbers. English and
Devanagari must be reviewed at 100%, 150%, and 200% scale. Numeric game values
need locale-aware formatting when presented outside real-time physics controls.
