import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/primary_button.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String? _selected;

  Future<void> _continue() async {
    if (_selected == null) return;
    await ref.read(localeProvider.notifier).setLocale(_selected!);
    await ref.read(preferencesRepositoryProvider).setOnboardingComplete(true);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF4F6F8),
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00897B).withValues(alpha: isDark ? 0.15 : 0.09),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  // Icon
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppTheme.brandGradient(),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00897B)
                                .withValues(alpha: 0.30),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.language_rounded,
                          color: Colors.white, size: 34),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.chooseLanguage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.chooseLanguageUrdu,
                    textAlign: TextAlign.center,
                    style: AppTheme.urduTextStyle(
                      context,
                      base: theme.textTheme.titleMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _LanguageCard(
                    title: l10n.english,
                    subtitle: 'English — Left to Right',
                    flag: '🇬🇧',
                    selected: _selected == 'en',
                    onTap: () => setState(() => _selected = 'en'),
                  ),
                  const SizedBox(height: 14),
                  _LanguageCard(
                    title: l10n.urdu,
                    subtitle: 'دائیں سے بائیں',
                    flag: '🇵🇰',
                    selected: _selected == 'ur',
                    isUrdu: true,
                    onTap: () => setState(() => _selected = 'ur'),
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: _selected != null ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: PrimaryButton(
                      label: l10n.continueButton,
                      enabled: _selected != null,
                      onPressed: _continue,
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.selected,
    required this.onTap,
    this.isUrdu = false,
  });

  final String title;
  final String subtitle;
  final String flag;
  final bool selected;
  final VoidCallback onTap;
  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? scheme.primary.withValues(alpha: isDark ? 0.16 : 0.08)
            : (isDark ? const Color(0xFF161B22) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? scheme.primary
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.07)),
          width: selected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                // Flag emoji
                Text(flag, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: isUrdu
                            ? AppTheme.urduTextStyle(
                                context,
                                base: theme.textTheme.titleLarge?.copyWith(
                                  color: selected ? scheme.primary : null,
                                ),
                              )
                            : theme.textTheme.titleLarge?.copyWith(
                                color: selected ? scheme.primary : null,
                              ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? scheme.primary : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? scheme.primary
                          : scheme.onSurface.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
