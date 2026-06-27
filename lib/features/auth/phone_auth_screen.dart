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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.continueWithPhone)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_otpSent) ...[
              Text(
                l10n.phoneNumber,
                style: context.localizedStyle(
                  Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: l10n.enterPhoneHint,
                  prefixText: '+92 ',
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: l10n.sendOtp,
                onPressed: _sendOtp,
              ),
            ] else ...[
              Text(
                l10n.enterOtp,
                style: context.localizedStyle(
                  Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                  fontWeight: FontWeight.w700,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: ''),
              ),
              const SizedBox(height: 8),
              Center(
                child: _secondsLeft > 0
                    ? Text(l10n.resendOtpIn(_secondsLeft))
                    : TextButton(
                        onPressed: _sendOtp,
                        child: Text(l10n.resendOtp),
                      ),
              ),
              const Spacer(),
              PrimaryButton(
                label: l10n.verifyOtp,
                onPressed: _verifyOtp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
