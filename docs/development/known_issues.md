# Known issues

## Open

1. Full application code and release-gate tests have not yet been implemented.
2. Android launcher images are Flutter scaffold defaults until original
   adaptive icon assets are generated and verified.
3. Release builds temporarily use the debug signing configuration so local CI
   can validate R8. Store publishing requires external release credentials.
4. The Flutter launcher prints a Windows `Zone.Identifier` cleanup warning in
   this development environment; Flutter continues normally.

## Resolved

- None yet.

Issues are never removed from this file without a resolution entry and date.
