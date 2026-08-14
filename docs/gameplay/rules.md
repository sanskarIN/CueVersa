# Rules profiles

CueVerse includes game state machines rather than claiming one universal house
rule. “WPA-inspired” describes an implementation informed by common tournament
principles; it is not an official ruling or certification.

## 8-ball

State covers break, open table, solids/stripes assignment, first legal contact,
post-contact rail/pocket requirement, scratch, ball in hand, continuing turn,
group clearance, called 8-ball, early/illegal 8-ball outcome, and finish. The 8
is respotted on the break in current profiles. Default dry break requires four
object balls to rails when no object ball is pocketed; casual profile relaxes
that and called-8 requirement.

The interactive v1 automatically treats the selected 8-ball pocket as called;
explicit called-pocket UI is an upcoming requirement. Cue-ball scratch resets
to a legal head-side position; free placement UI is upcoming.

## 9-ball

The lowest numbered remaining ball must be contacted first. A legal pocket
continues the turn. A legal combination that pockets 9 wins. Nine pocketed on a
foul is respotted. Scratch, no contact, wrong contact, and no later rail/pocket
grant ball in hand.

## Changes

Rule changes require a named profile/version, source review for claims,
state-machine regressions, full-match manual scenarios, migration/replay impact,
UI text, and release notes.
