import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/primary_button.dart';

class UnitsInputScreen extends ConsumerStatefulWidget {
  const UnitsInputScreen({super.key});

  @override
  ConsumerState<UnitsInputScreen> createState() => _UnitsInputScreenState();
}

class _UnitsInputScreenState extends ConsumerState<UnitsInputScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final l10n = context.l10n;
    final text = _controller.text.trim();
    final units = int.tryParse(text);

    if (units == null || units <= 0) {
      setState(() => _error = l10n.invalidUnits);
      return;
    }

    setState(() => _error = null);
    final result =
        await ref.read(billSessionProvider.notifier).calculate(units);
    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectDiscoAndCategory)),
      );
      return;
    }

    context.push('/result');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final session = ref.watch(billSessionProvider);

    final categoryLabel = session.category == ConsumerCategory.protected
        ? l10n.protected
        : l10n.unprotected;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calculateBill),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${session.disco ?? ''} • $categoryLabel',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: Text(l10n.editSelection),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              context.isUrdu ? l10n.enterUnitsUrdu : l10n.enterUnits,
              textAlign: TextAlign.center,
              style: context.localizedStyle(
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              decoration: InputDecoration(
                hintText: '0',
                suffixText: 'kWh',
                errorText: _error,
              ),
              onSubmitted: (_) => _calculate(),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.unitsHelper,
              textAlign: TextAlign.center,
              style: context.localizedStyle(
                theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: l10n.calculateBill,
              icon: Icons.calculate_rounded,
              onPressed: _calculate,
            ),
          ],
        ),
      ),
    );
  }
}
