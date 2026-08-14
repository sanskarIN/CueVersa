import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

Future<void> openExternalLink(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.of(context);
  final localizations = AppLocalizations.of(context);
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    opened = false;
  }
  if (!opened && context.mounted) {
    messenger.showSnackBar(SnackBar(content: Text(localizations.linkFailed)));
  }
}
