import 'package:flutter/material.dart';

import '../../../core/constants/project_links.dart';
import '../../../core/utils/external_links.dart';
import '../../../core/widgets/brand_widgets.dart';
import '../../../l10n/app_localizations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.support)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const BmcSupportCard(),
          const SizedBox(height: 16),
          _LinkTile(
            icon: Icons.support_agent_rounded,
            title: localizations.supportEmail,
            subtitle: 'supportramsandesh@gmail.com',
            uri: ProjectLinks.supportEmail,
          ),
          _LinkTile(
            icon: Icons.business_center_outlined,
            title: localizations.businessEmail,
            subtitle: 'sanskarin@outlook.in',
            uri: ProjectLinks.businessEmail,
          ),
          _LinkTile(
            icon: Icons.alternate_email_rounded,
            title: localizations.businessEmail,
            subtitle: 'sanskarin.business@gmail.com',
            uri: ProjectLinks.alternateBusinessEmail,
          ),
          _LinkTile(
            icon: Icons.code_rounded,
            title: localizations.repository,
            subtitle: 'github.com/sanskarIN/CueVersa',
            uri: ProjectLinks.repository,
          ),
          const SizedBox(height: 24),
          const CreatorWatermark(),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.uri,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          minTileHeight: 68,
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.open_in_new_rounded),
          onTap: () => openExternalLink(context, uri),
        ),
      ),
    );
  }
}
