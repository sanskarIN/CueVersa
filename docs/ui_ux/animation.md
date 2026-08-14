# Animation and motion

Ball motion is simulation-driven, not decorative easing. Navigation uses the
platform predictive-back transition except the zero-duration splash replacement.
The current design intentionally avoids nonessential particles and large
parallax until performance and reduced-motion behavior are proven.

When reduced motion is enabled, MediaQuery disables animations and AI thinking
delay is shortened. Future micro-interactions must be brief, interruptible,
meaningful, and omitted/substituted under reduced motion. Never delay input or
insert an artificial multi-second splash.
