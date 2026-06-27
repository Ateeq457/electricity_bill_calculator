import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _completeLogin(
    WidgetRef ref,
    BuildContext context, {
    required AuthMethod method,
    String? displayName,
  }) async {
    await ref.read(authProvider.notifier).signIn(
          method: method,
          displayName: displayName,
        );
    if (!context.mounted) return;

    final onboarding = ref.read(onboardingCompleteProvider);
    context.go(onboarding ? '/home' : '/language');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: AppTheme.heroGradient(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const AppLogo(size: 88),
                const SizedBox(height: 28),
                Text(
                  l10n.signInWelcome,
                  textAlign: TextAlign.center,
                  style: context.localizedStyle(
                    theme.textTheme.titleLarge?.copyWith(height: 1.4),
                  ),
                ),
                const Spacer(flex: 3),
                PrimaryButton(
                  label: l10n.continueWithGoogle,
                  icon: Icons.g_mobiledata_rounded,
                  onPressed: () => _completeLogin(
                    ref,
                    context,
                    method: AuthMethod.google,
                    displayName: 'Google User',
                  ),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: l10n.continueWithPhone,
                  icon: const Icon(Icons.phone_android_rounded, size: 20),
                  onPressed: () => context.push('/login/phone'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.push('/login/email'),
                  child: Text(l10n.continueWithEmail),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _completeLogin(
                    ref,
                    context,
                    method: AuthMethod.guest,
                    displayName: l10n.guestUser,
                  ),
                  child: Text(l10n.continueAsGuest),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
