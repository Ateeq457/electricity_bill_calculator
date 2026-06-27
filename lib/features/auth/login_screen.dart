import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;

  Future<void> _completeLogin({
    required AuthMethod method,
    String? displayName,
    String? uid,
  }) async {
    await ref
        .read(authProvider.notifier)
        .signIn(method: method, displayName: displayName);

    // Create Firestore user doc
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
    setState(() => _loading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _loading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      await _completeLogin(
        method: AuthMethod.google,
        displayName: userCred.user?.displayName ?? googleUser.displayName,
        uid: userCred.user?.uid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _guestSignIn() async {
    setState(() => _loading = true);
    try {
      final userCred = await FirebaseAuth.instance.signInAnonymously();
      await _completeLogin(
        method: AuthMethod.guest,
        displayName: 'Guest',
        uid: userCred.user?.uid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Guest sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                if (_loading)
                  const CircularProgressIndicator()
                else ...[
                  PrimaryButton(
                    label: l10n.continueWithGoogle,
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: _googleSignIn,
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
                    onPressed: _guestSignIn,
                    child: Text(l10n.continueAsGuest),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
