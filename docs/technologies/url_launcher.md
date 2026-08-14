# url_launcher

Purpose: launch explicitly selected HTTPS or `mailto:` actions for repository,
creator, BMC, support, and business contact links.

All URIs are constants controlled by CueVerse. Launches use external-application
mode and display a localized failure message. No support link opens during
gameplay, no click is tracked, and failure does not block any feature.

Future dynamic URLs must be allowlisted by scheme and host and must reject
untrusted `javascript:`, file, intent, or credential-bearing URIs.

License: BSD 3-Clause.
