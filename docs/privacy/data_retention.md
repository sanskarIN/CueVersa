# Data retention and deletion

Local settings and aggregate progress persist until the user confirms “Delete
all local data,” Android clears application storage, or the app is uninstalled.
Restoring defaults removes setting keys; deleting all local data removes both
settings and progress. Current code has no remote copy to delete.

Future match history should use configurable bounded retention rather than grow
forever. Future services require published retention windows, deletion-request
authentication, backup-expiry behavior, legal-hold rules only where applicable,
and audit records that do not recreate deleted content.

Exports/imports are not implemented. When introduced, exported files become
user-controlled copies and must carry version/integrity metadata plus clear
deletion guidance.
