import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_providers.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/app_logo.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen(appInitializationProvider, (previous, next) {
      next.whenData((_) {
        if (!context.mounted) return;
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          final onboarding = ref.read(onboardingCompleteProvider);
          context.go(onboarding ? '/home' : '/language');
        } else {
          context.go('/login');
        }
      });
    });

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF4F6F8),
      body: Stack(
        children: [
          // Subtle radial glow at top
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00897B).withValues(alpha: isDark ? 0.18 : 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  const AppLogo(size: 100),
                  const SizedBox(height: 28),
                  Text(
                    l10n.appName,
                    style: context.localizedStyle(
                      theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.appTagline,
                    style: context.localizedStyle(
                      theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 3),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: theme.colorScheme.primary,
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Pakistan Electricity Bill Calculator',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
