# Responsive layout

Home uses an extent-based sliver grid so columns follow available width without
phone/tablet breakpoints. Content screens use scrollable lists/grids.

Gameplay is portrait-first: the 2:1 table expands above a bottom control tray.
When width exceeds height, the table and a vertically scrollable 290 dp control
rail share a row. Controls reflow vertically to prevent narrow landscape
overflow. Left-handed mode reverses control priority without mirroring table
physics.

QA covers 320–1440 logical-pixel widths, portrait/landscape, split screen,
display cutouts, 200% text, tablets, and foldable hinge-safe layouts. Avoid
placing critical controls under system insets; all primary screens use SafeArea.
