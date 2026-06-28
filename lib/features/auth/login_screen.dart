import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/app_logo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;
  String? _loadingFor;

  Future<void> _completeLogin({
    required AuthMethod method,
    String? displayName,
    String? uid,
  }) async {
    await ref
        .read(authProvider.notifier)
        .signIn(method: method, displayName: displayName);

    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'displayName': displayName,
        'loginMethod': method.name,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    if (!mounted) return;
    final onboarding = ref.read(onboardingCompleteProvider);
    context.go(onboarding ? '/home' : '/language');
  }

  Future<void> _googleSignIn() async {
    setState(() { _loading = true; _loadingFor = 'google'; });
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) { setState(() => _loading = false); return; }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await _completeLogin(
        method: AuthMethod.google,
        displayName: userCred.user?.displayName ?? googleUser.displayName,
        uid: userCred.user?.uid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() { _loading = false; _loadingFor = null; });
    }
  }

  Future<void> _guestSignIn() async {
    setState(() { _loading = true; _loadingFor = 'guest'; });
    try {
      final userCred = await FirebaseAuth.instance.signInAnonymously();
      await _completeLogin(
        method: AuthMethod.guest,
        displayName: 'Guest',
        uid: userCred.user?.uid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() { _loading = false; _loadingFor = null; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF4F6F8),
      body: Stack(
        children: [
          // Radial glow bg
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00897B).withValues(alpha: isDark ? 0.20 : 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // Logo + title
                  Center(child: const AppLogo(size: 80)),
                  const SizedBox(height: 24),
                  Text(
                    l10n.signInWelcome,
                    textAlign: TextAlign.center,
                    style: context.localizedStyle(
                      theme.textTheme.titleLarge?.copyWith(height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pakistan Electricity Bill Calculator',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),

                  const Spacer(flex: 3),

                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    // Google Sign-In — premium looking with brand colors
                    _GoogleButton(onPressed: _googleSignIn),
                    const SizedBox(height: 12),
                    // Phone
                    _AuthOptionButton(
                      icon: Icons.phone_android_rounded,
                      label: l10n.continueWithPhone,
                      onPressed: () => context.push('/login/phone'),
                    ),
                    const SizedBox(height: 12),
                    // Email
                    _AuthOptionButton(
                      icon: Icons.email_outlined,
                      label: l10n.continueWithEmail,
                      onPressed: () => context.push('/login/email'),
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: scheme.onSurface.withValues(alpha: 0.12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: scheme.onSurface.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Guest
                    TextButton(
                      onPressed: _guestSignIn,
                      child: Text(
                        l10n.continueAsGuest,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ],
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

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF1E2433) : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF1F2937),
          elevation: 0,
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple G icon representation
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.g_mobiledata_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Text('Continue with Google'),
          ],
        ),
      ),
    );
  }
}

class _AuthOptionButton extends StatelessWidget {
  const _AuthOptionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: scheme.primary),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : const Color(0xFF1F2937),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
