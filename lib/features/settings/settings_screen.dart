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
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final auth = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final prefs = ref.watch(preferencesRepositoryProvider);
    final session = ref.watch(billSessionProvider);

    return MainShell(
      currentIndex: 2,
      title: l10n.settings,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [

          // ── Account ─────────────────────────────────────────
          _SectionLabel(title: l10n.account),
          _SettingsCard(
            children: [
              _AccountTile(auth: auth, l10n: l10n),
              _DividerLine(),
              _SettingsTile(
                icon: auth.isAuthenticated && auth.method != AuthMethod.guest
                    ? Icons.logout_rounded
                    : Icons.login_rounded,
                iconColor: auth.isAuthenticated && auth.method != AuthMethod.guest
                    ? scheme.error
                    : scheme.primary,
                title: auth.isAuthenticated && auth.method != AuthMethod.guest
                    ? l10n.signOut
                    : l10n.signIn,
                textColor: auth.isAuthenticated && auth.method != AuthMethod.guest
                    ? scheme.error
                    : null,
                onTap: () async {
                  if (auth.isAuthenticated && auth.method != AuthMethod.guest) {
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

          const SizedBox(height: 20),

          // ── Language ─────────────────────────────────────────
          _SectionLabel(title: l10n.language),
          _SettingsCard(
            children: [
              _RadioTile<Locale>(
                icon: Icons.language_rounded,
                iconColor: scheme.primary,
                title: l10n.english,
                value: const Locale('en'),
                groupValue: locale,
                onChanged: (v) {
                  if (v != null) ref.read(localeProvider.notifier).setLocale('en');
                },
              ),
              _DividerLine(),
              _RadioTile<Locale>(
                icon: Icons.translate_rounded,
                iconColor: scheme.secondary,
                title: l10n.urdu,
                value: const Locale('ur'),
                groupValue: locale,
                onChanged: (v) {
                  if (v != null) ref.read(localeProvider.notifier).setLocale('ur');
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Appearance ───────────────────────────────────────
          _SectionLabel(title: l10n.theme),
          _SettingsCard(
            children: [
              _RadioTile<ThemeMode>(
                icon: Icons.light_mode_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: l10n.themeLight,
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: (v) {
                  if (v != null) ref.read(themeModeProvider.notifier).setAppThemeMode(AppThemeMode.light);
                },
              ),
              _DividerLine(),
              _RadioTile<ThemeMode>(
                icon: Icons.dark_mode_rounded,
                iconColor: const Color(0xFF6366F1),
                title: l10n.themeDark,
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: (v) {
                  if (v != null) ref.read(themeModeProvider.notifier).setAppThemeMode(AppThemeMode.dark);
                },
              ),
              _DividerLine(),
              _RadioTile<ThemeMode>(
                icon: Icons.brightness_auto_rounded,
                iconColor: scheme.primary,
                title: l10n.themeSystem,
                value: ThemeMode.system,
                groupValue: themeMode,
                onChanged: (v) {
                  if (v != null) ref.read(themeModeProvider.notifier).setAppThemeMode(AppThemeMode.system);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── About & Support ──────────────────────────────────
          _SectionLabel(title: l10n.aboutApp),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: scheme.primary,
                title: l10n.aboutApp,
                subtitle: l10n.aboutAppDescription,
              ),
              _DividerLine(),
              _SettingsTile(
                icon: Icons.flag_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: l10n.feedback,
                onTap: () {
                  if (session.result != null) {
                    showReportIssueSheet(context, session.result!);
                  } else {
                    _openUrl('mailto:${AppConstants.feedbackEmail}');
                  }
                },
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ),
              _DividerLine(),
              _SettingsTile(
                icon: Icons.star_outline_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: l10n.rateThisApp,
                onTap: () => _openUrl(AppConstants.playStoreUrl),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ),
              _DividerLine(),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: scheme.secondary,
                title: l10n.privacyPolicy,
                onTap: () => _openUrl(AppConstants.privacyPolicyUrl),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ),
            ],
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              l10n.version('1.0.0'),
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      child: Text(
        title.toUpperCase(),
        style: context.localizedStyle(
          Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.0,
              ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.auth, required this.l10n});
  final AuthState auth;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00897B), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.displayName ?? l10n.guestUser,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    auth.method.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.iconColor,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final Color? iconColor;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = iconColor ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.15 : 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.localizedStyle(
                      theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: context.localizedStyle(
                        theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              IconTheme(
                data: IconThemeData(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  size: 14,
                ),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  const _RadioTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.15 : 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: context.localizedStyle(
                  theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.25),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
