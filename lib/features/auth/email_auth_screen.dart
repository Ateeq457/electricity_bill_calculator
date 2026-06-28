import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';

class EmailAuthScreen extends ConsumerStatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  ConsumerState<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends ConsumerState<EmailAuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _loading = false;
  bool _obscure = true;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _errorMsg = null; });

    try {
      UserCredential userCred;

      if (_isLogin) {
        userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      } else {
        userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
        await userCred.user?.sendEmailVerification();

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Verify your email'),
              content: Text(
                'A verification email has been sent to ${_emailCtrl.text.trim()}.\n\nPlease verify before signing in.',
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _isLogin = true);
                  },
                  child: const Text('Got it'),
                ),
              ],
            ),
          );
          setState(() => _loading = false);
          return;
        }
      }

      final user = userCred.user;
      if (user == null) return;

      if (_isLogin && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _errorMsg = 'Please verify your email first. Check your inbox.';
          _loading = false;
        });
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? user.email?.split('@').first,
        'loginMethod': AuthMethod.email.name,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await ref.read(authProvider.notifier).signIn(
            method: AuthMethod.email,
            displayName: user.displayName ?? user.email?.split('@').first,
          );

      if (!mounted) return;
      final onboarding = ref.read(onboardingCompleteProvider);
      context.go(onboarding ? '/home' : '/language');
    } on FirebaseAuthException catch (e) {
      setState(() { _errorMsg = _friendlyError(e.code); _loading = false; });
    } catch (e) {
      setState(() { _errorMsg = e.toString(); _loading = false; });
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Sign In' : 'Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Header
                Text(
                  _isLogin ? 'Welcome back' : 'Create your account',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isLogin
                      ? 'Sign in to sync your bill history'
                      : 'Join to keep track of your electricity bills',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),

                const SizedBox(height: 32),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (!_isLogin && v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                // Error
                if (_errorMsg != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: scheme.onErrorContainer, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMsg!,
                            style: TextStyle(
                                color: scheme.onErrorContainer, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(_isLogin ? 'Sign In' : 'Create Account'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() {
                    _isLogin = !_isLogin;
                    _errorMsg = null;
                  }),
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign up"
                        : 'Already have an account? Sign in',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
