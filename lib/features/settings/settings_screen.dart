import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/main_shell.dart';
import '../feedback/report_issue_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final prefs = ref.watch(preferencesRepositoryProvider);
    final session = ref.watch(billSessionProvider);

    return MainShell(
      currentIndex: 2,
      title: l10n.settings,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: l10n.account),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.person_rounded,
                        color: theme.colorScheme.primary),
                  ),
                  title: Text(
                    auth.displayName ?? l10n.guestUser,
                    style: context.localizedStyle(null),
                  ),
                  subtitle: Text(auth.method.name.toUpperCase()),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.login_rounded),
                  title: Text(
                    auth.isAuthenticated && auth.method != AuthMethod.guest
                        ? l10n.signOut
                        : l10n.signIn,
                  ),
                  onTap: () async {
                    if (auth.isAuthenticated &&
                        auth.method != AuthMethod.guest) {
                      await ref.read(authProvider.notifier).signOut();
                      await prefs.setOnboardingComplete(false);
                      if (context.mounted) context.go('/login');
                    } else {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.language),
          Card(
            child: Column(
              children: [
                RadioListTile<Locale>(
                  title: Text(l10n.english),
                  value: const Locale('en'),
                  groupValue: locale,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).setLocale('en');
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<Locale>(
                  title: Text(
                    l10n.urdu,
                    style: context.isUrdu
                        ? null
                        : Theme.of(context).textTheme.bodyLarge,
                  ),
                  value: const Locale('ur'),
                  groupValue: locale,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).setLocale('ur');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.theme),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeLight),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setAppThemeMode(AppThemeMode.light);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeDark),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setAppThemeMode(AppThemeMode.dark);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeSystem),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setAppThemeMode(AppThemeMode.system);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.aboutApp),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(l10n.aboutApp),
                  subtitle: Text(
                    l10n.aboutAppDescription,
                    style: context.localizedStyle(
                      theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text(l10n.feedback),
                  onTap: () {
                    if (session.result != null) {
                      showReportIssueSheet(context, session.result!);
                    } else {
                      _openUrl(
                        'mailto:${AppConstants.feedbackEmail}',
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star_outline_rounded),
                  title: Text(l10n.rateThisApp),
                  onTap: () => _openUrl(AppConstants.playStoreUrl),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.privacyPolicy),
                  onTap: () => _openUrl(AppConstants.privacyPolicyUrl),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              l10n.version('1.0.0'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Text(
        title,
        style: context.localizedStyle(
          Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }
}
