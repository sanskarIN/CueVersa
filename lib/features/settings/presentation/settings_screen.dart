import 'package:flutter/material.dart';

import '../../../app/app_progress.dart';
import '../../../app/app_settings.dart';
import '../../../core/widgets/brand_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../more/presentation/content_screens.dart';
import '../../support/presentation/support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.settings,
    required this.progress,
    super.key,
  });

  final AppSettings settings;
  final AppProgress progress;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _versionTaps = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text(localizations.settings)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _Section(
              title: localizations.settingsAppearance,
              icon: Icons.palette_outlined,
              children: <Widget>[
                ListTile(
                  title: Text(localizations.theme),
                  trailing: DropdownButton<AppThemePreference>(
                    value: widget.settings.theme,
                    onChanged: (value) {
                      if (value != null) widget.settings.setTheme(value);
                    },
                    items: <DropdownMenuItem<AppThemePreference>>[
                      DropdownMenuItem(
                        value: AppThemePreference.system,
                        child: Text(localizations.themeSystem),
                      ),
                      DropdownMenuItem(
                        value: AppThemePreference.light,
                        child: Text(localizations.themeLight),
                      ),
                      DropdownMenuItem(
                        value: AppThemePreference.dark,
                        child: Text(localizations.themeDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsGeneral,
              icon: Icons.home_outlined,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: Text(localizations.tutorial),
                  onTap: () => _open(const TutorialScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(localizations.rulesGuide),
                  onTap: () => _open(const RulesGuideScreen()),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsGameplay,
              icon: Icons.sports_esports_outlined,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.science_outlined),
                  title: Text(localizations.practice),
                  subtitle: Text(localizations.offlineOnly),
                ),
                ListTile(
                  leading: const Icon(Icons.auto_awesome_outlined),
                  title: Text(localizations.cosmetics),
                  subtitle: Text(localizations.freeAndFair),
                  onTap: () => _open(const CosmeticsScreen()),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsControls,
              icon: Icons.control_camera_rounded,
              children: <Widget>[
                SwitchListTile.adaptive(
                  value: widget.settings.leftHanded,
                  title: Text(localizations.leftHanded),
                  onChanged: widget.settings.setLeftHanded,
                ),
                ListTile(
                  title: Text(localizations.aimSensitivity),
                  subtitle: Slider(
                    value: widget.settings.aimSensitivity,
                    min: .5,
                    max: 2,
                    divisions: 6,
                    label: widget.settings.aimSensitivity.toStringAsFixed(1),
                    onChanged: widget.settings.setAimSensitivity,
                  ),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsSound,
              icon: Icons.volume_up_outlined,
              children: <Widget>[
                SwitchListTile.adaptive(
                  value: widget.settings.soundEffects,
                  title: Text(localizations.soundEffects),
                  onChanged: widget.settings.setSoundEffects,
                ),
                SwitchListTile.adaptive(
                  value: widget.settings.music,
                  title: Text(localizations.music),
                  onChanged: widget.settings.setMusic,
                ),
                SwitchListTile.adaptive(
                  value: widget.settings.haptics,
                  title: Text(localizations.haptics),
                  onChanged: widget.settings.setHaptics,
                ),
              ],
            ),
            _Section(
              title: localizations.settingsAccessibility,
              icon: Icons.accessibility_new_rounded,
              children: <Widget>[
                SwitchListTile.adaptive(
                  value: widget.settings.highContrast,
                  title: Text(localizations.highContrast),
                  onChanged: widget.settings.setHighContrast,
                ),
                SwitchListTile.adaptive(
                  value: widget.settings.reducedMotion,
                  title: Text(localizations.reducedMotion),
                  onChanged: widget.settings.setReducedMotion,
                ),
              ],
            ),
            _Section(
              title: localizations.settingsLanguage,
              icon: Icons.translate_rounded,
              children: <Widget>[
                RadioGroup<String>(
                  groupValue: widget.settings.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) widget.settings.setLocale(Locale(value));
                  },
                  child: Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        value: 'en',
                        title: Text(localizations.languageEnglish),
                      ),
                      RadioListTile<String>(
                        value: 'hi',
                        title: Text(localizations.languageHindi),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsNotifications,
              icon: Icons.notifications_none_rounded,
              children: <Widget>[
                ListTile(
                  title: Text(localizations.notificationsDisabled),
                  leading: const Icon(Icons.notifications_off_outlined),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsPerformance,
              icon: Icons.speed_rounded,
              children: <Widget>[
                SwitchListTile.adaptive(
                  value: widget.settings.batterySaver,
                  title: Text(localizations.batterySaver),
                  onChanged: widget.settings.setBatterySaver,
                ),
              ],
            ),
            _Section(
              title: localizations.settingsData,
              icon: Icons.storage_rounded,
              children: <Widget>[
                ListTile(
                  title: Text(localizations.restoreDefaults),
                  leading: const Icon(Icons.settings_backup_restore_rounded),
                  onTap: _restoreDefaults,
                ),
                ListTile(
                  title: Text(localizations.deleteLocalData),
                  leading: const Icon(Icons.delete_outline_rounded),
                  textColor: Theme.of(context).colorScheme.error,
                  iconColor: Theme.of(context).colorScheme.error,
                  onTap: _deleteLocalData,
                ),
              ],
            ),
            _Section(
              title: localizations.settingsPrivacy,
              icon: Icons.privacy_tip_outlined,
              children: <Widget>[
                ListTile(
                  title: Text(localizations.privacyPolicy),
                  subtitle: Text(localizations.offlineOnly),
                  onTap: () => _open(const AboutScreen()),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsSecurity,
              icon: Icons.shield_outlined,
              children: <Widget>[
                ListTile(
                  title: Text(localizations.secureLocalData),
                  leading: const Icon(Icons.phonelink_lock_outlined),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsOnline,
              icon: Icons.public_off_outlined,
              children: <Widget>[
                ListTile(
                  title: Text(localizations.onlineComingSoon),
                  subtitle: Text(localizations.offlineOnly),
                ),
              ],
            ),
            _Section(
              title: localizations.settingsLegal,
              icon: Icons.gavel_outlined,
              children: <Widget>[
                ListTile(title: Text(localizations.privacyPolicy)),
                ListTile(title: Text(localizations.terms)),
                ListTile(title: Text(localizations.thirdPartyNotices)),
              ],
            ),
            const SizedBox(height: 8),
            const BmcSupportCard(),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.favorite_outline_rounded),
                    title: Text(localizations.support),
                    onTap: () => _open(const SupportScreen()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: Text(localizations.about),
                    subtitle: Text(localizations.versionLabel('1.0.0+1')),
                    onTap: _handleVersionTap,
                    trailing: IconButton(
                      tooltip: localizations.about,
                      onPressed: () => _open(const AboutScreen()),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  if (widget.settings.developerUnlocked)
                    ListTile(
                      leading: const Icon(Icons.developer_mode_rounded),
                      title: Text(localizations.settingsDeveloper),
                      subtitle: Text(localizations.secureLocalData),
                      onTap: () => _open(const DeveloperOptionsScreen()),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _restoreDefaults() async {
    await widget.settings.restoreDefaults();
  }

  Future<void> _deleteLocalData() async {
    final localizations = AppLocalizations.of(context);
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteLocalData),
        content: Text(localizations.deleteDataWarning),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
    if (accepted ?? false) {
      await widget.progress.clear();
      await widget.settings.restoreDefaults();
    }
  }

  void _handleVersionTap() {
    final localizations = AppLocalizations.of(context);
    if (widget.settings.developerUnlocked) {
      _open(const AboutScreen());
      return;
    }
    _versionTaps++;
    if (_versionTaps >= 7) {
      widget.settings.unlockDeveloperOptions();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.developerUnlocked)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.developerUnlockProgress(7 - _versionTaps),
          ),
          duration: const Duration(milliseconds: 750),
        ),
      );
    }
  }

  void _open(Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (context) => screen));
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded:
              title == AppLocalizations.of(context).settingsAppearance,
          leading: Icon(icon),
          title: Text(title),
          children: children,
        ),
      ),
    );
  }
}
