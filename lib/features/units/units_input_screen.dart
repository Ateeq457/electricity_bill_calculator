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
  final _focusNode = FocusNode();
  String? _error;
  bool _calculating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _controller.addListener(() {
      if (_error != null) setState(() => _error = null);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
    if (units > 9999) {
      setState(() => _error = 'Please enter a valid unit count (max 9999)');
      return;
    }

    setState(() {
      _error = null;
      _calculating = true;
    });
    final result = await ref
        .read(billSessionProvider.notifier)
        .calculate(units);
    if (!mounted) return;
    setState(() => _calculating = false);

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectDiscoAndCategory)));
      return;
    }

    context.push('/result');
  }

  String _currentUnitsLabel(String text) {
    final n = int.tryParse(text);
    if (n == null || n == 0) return '';
    if (n <= 50) return 'Very Low Usage';
    if (n <= 100) return 'Low Usage';
    if (n <= 200) return 'Moderate';
    if (n <= 400) return 'High Usage';
    return 'Very High Usage';
  }

  Color _usageColor(String text, ColorScheme scheme) {
    final n = int.tryParse(text) ?? 0;
    if (n <= 100) return const Color(0xFF16A34A);
    if (n <= 200) return const Color(0xFF2563EB);
    if (n <= 400) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final session = ref.watch(billSessionProvider);

    final categoryLabel = session.category == ConsumerCategory.protected
        ? l10n.protected
        : l10n.unprotected;

    final currentText = _controller.text;
    final usageLabel = _currentUnitsLabel(currentText);
    final usageColor = _usageColor(currentText, scheme);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calculateBill),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16), // Reduced from 24
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selection chip row - Made more compact
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ), // Reduced padding
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B22) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.electrical_services_rounded,
                        color: scheme.primary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            session.disco ?? '',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            categoryLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.editSelection,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // Use Expanded for scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16), // Reduced from 40
                        // Prompt
                        Text(
                          context.isUrdu
                              ? l10n.enterUnitsUrdu
                              : l10n.enterUnits,
                          textAlign: TextAlign.center,
                          style: context.localizedStyle(
                            theme.textTheme.titleMedium?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Reduced from 24
                        // Big input - Smaller font
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 40, // Smaller font
                            color: _error != null ? scheme.error : null,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: theme.textTheme.displayMedium?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.15),
                              fontWeight: FontWeight.w800,
                              fontSize: 40,
                            ),
                            suffixText: 'kWh',
                            suffixStyle: theme.textTheme.titleLarge?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.35),
                              fontSize: 18,
                            ),
                            errorText: _error,
                            errorStyle: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.error,
                              fontSize: 12,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: (_) => _calculate(),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10), // Reduced from 12
                        // Usage indicator
                        if (usageLabel.isNotEmpty) ...[
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: usageColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: usageColor.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              usageLabel,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: usageColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],

                        // Hint
                        Text(
                          l10n.unitsHelper,
                          textAlign: TextAlign.center,
                          style: context.localizedStyle(
                            theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.45),
                              fontSize: 11,
                            ),
                          ),
                        ),

                        // Quick select chips
                        const SizedBox(height: 16), // Reduced from 24
                        Text(
                          'Quick select',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.45),
                            letterSpacing: 0.5,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8), // Reduced from 10
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children: [50, 100, 200, 300, 500].map((units) {
                            return InkWell(
                              onTap: () {
                                _controller.text = units.toString();
                                setState(() => _error = null);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.06)
                                      : Colors.black.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.10)
                                        : Colors.black.withValues(alpha: 0.07),
                                  ),
                                ),
                                child: Text(
                                  '$units',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Calculate button - Fixed at bottom
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: PrimaryButton(
                  label: l10n.calculateBill,
                  icon: Icons.calculate_rounded,
                  onPressed: _calculate,
                  isLoading: _calculating,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
