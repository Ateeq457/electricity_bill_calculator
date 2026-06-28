import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/primary_button.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().length < 10) return;
    setState(() => _otpSent = true);
    _startTimer();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.otpSent)),
    );
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) return;
    await ref.read(authProvider.notifier).signIn(
          method: AuthMethod.phone,
          displayName: _phoneController.text.trim(),
        );
    if (!mounted) return;
    final onboarding = ref.read(onboardingCompleteProvider);
    context.go(onboarding ? '/home' : '/language');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.continueWithPhone),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              if (!_otpSent) ...[
                Text(
                  'Enter your phone number',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "We'll send a 6-digit OTP to verify",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    hintText: l10n.enterPhoneHint,
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    prefixText: '+92  ',
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: l10n.sendOtp,
                  icon: Icons.send_rounded,
                  onPressed: _sendOtp,
                ),
              ] else ...[
                Text(
                  'Enter OTP',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Code sent to +92 ${_phoneController.text}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 32),
                // OTP boxes
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 16,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '------',
                    hintStyle: theme.textTheme.displaySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.15),
                      letterSpacing: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onChanged: (v) {
                    if (v.length == 6) _verifyOtp();
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: _secondsLeft > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer_outlined,
                                size: 14,
                                color:
                                    scheme.onSurface.withValues(alpha: 0.45)),
                            const SizedBox(width: 6),
                            Text(
                              l10n.resendOtpIn(_secondsLeft),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    scheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        )
                      : TextButton(
                          onPressed: _sendOtp,
                          child: Text(l10n.resendOtp),
                        ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: l10n.verifyOtp,
                  icon: Icons.verified_rounded,
                  onPressed: _verifyOtp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
