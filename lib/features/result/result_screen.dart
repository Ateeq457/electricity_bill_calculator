import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/tariff_model.dart';
import '../../shared/extensions/localized_text.dart';
import '../feedback/report_issue_sheet.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  String _categoryLabel(BuildContext context, BillBreakdown result) {
    final l10n = context.l10n;
    return result.category == ConsumerCategory.protected
        ? l10n.protected
        : l10n.unprotected;
  }

  Future<void> _share(BuildContext context, BillBreakdown result) async {
    final l10n = context.l10n;
    await Share.share(
      l10n.shareBillText(
        result.disco,
        _categoryLabel(context, result),
        result.units.toString(),
        CurrencyFormatter.format(result.total),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final session = ref.watch(billSessionProvider);
    final result = session.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.estimatedBill)),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/home'),
            child: Text(l10n.home),
          ),
        ),
      );
    }

    final breakdownRows = [
      (l10n.energyCharges, result.energyCharges, Icons.flash_on_rounded),
      (l10n.fixedCharges, result.fixedCharges, Icons.receipt_outlined),
      (l10n.gst, result.gst, Icons.percent_rounded),
      (l10n.fpa, result.fpa, Icons.local_gas_station_outlined),
      (l10n.electricityDuty, result.electricityDuty, Icons.account_balance_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.estimatedBill),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _share(context, result),
            tooltip: l10n.share,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                // ── Total Bill Card ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.brandGradient(),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFF00897B).withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // DISCO + category badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.electrical_services_rounded,
                                    size: 14, color: Colors.white70),
                                const SizedBox(width: 6),
                                Text(
                                  '${result.disco} · ${_categoryLabel(context, result)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.totalEstimatedBill,
                        style: context.localizedStyle(
                          const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${l10n.pkr} ${CurrencyFormatter.format(result.total)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${result.units} ${l10n.units} consumed',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Breakdown Card ───────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B22) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                        child: Row(
                          children: [
                            Icon(Icons.receipt_long_rounded,
                                size: 18, color: scheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Bill Breakdown',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...breakdownRows.asMap().entries.map((entry) {
                        final i = entry.key;
                        final (label, amount, icon) = entry.value;
                        final isLast = i == breakdownRows.length - 1;
                        return _BreakdownRow(
                          label: label,
                          amount: amount,
                          icon: icon,
                          isLast: isLast,
                          pkrLabel: l10n.pkr,
                          localizedLabel: context.isUrdu,
                        );
                      }),
                      // Divider + total repeat
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Divider(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.totalEstimatedBill,
                                style: context.localizedStyle(
                                  theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${l10n.pkr} ${CurrencyFormatter.format(result.total)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Disclaimer ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Color(0xFFF59E0B), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.disclaimer,
                          style: context.localizedStyle(
                            theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? const Color(0xFFFBBF24)
                                  : const Color(0xFF92400E),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Rates metadata
                Row(
                  children: [
                    Icon(Icons.update_rounded,
                        size: 14,
                        color: scheme.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(width: 6),
                    Text(
                      l10n.ratesLastUpdated(
                        DateFormatter.formatIsoDate(result.lastUpdated),
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),

                if (result.ratesStale) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 14, color: scheme.error),
                      const SizedBox(width: 6),
                      Text(
                        l10n.ratesMayBeOutdated,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // ── Action Buttons ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.calculate_rounded,
                        label: l10n.calculateAgain,
                        color: scheme.primary,
                        onTap: () => context.go('/units'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.flag_outlined,
                        label: l10n.reportIssue,
                        color: const Color(0xFFF59E0B),
                        onTap: () => showReportIssueSheet(context, result),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.share_rounded,
                        label: l10n.share,
                        color: const Color(0xFF6366F1),
                        onTap: () => _share(context, result),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _AdPlaceholder(label: l10n.adPlaceholder),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.icon,
    required this.pkrLabel,
    required this.localizedLabel,
    this.isLast = false,
  });

  final String label;
  final double amount;
  final IconData icon;
  final String pkrLabel;
  final bool localizedLabel;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon,
                    size: 16, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: localizedLabel
                      ? theme.textTheme.bodyMedium?.copyWith(fontFamily: null)
                      : theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                '${pkrLabel} ${CurrencyFormatter.format(amount)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: color.withValues(alpha: isDark ? 0.12 : 0.07),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.20),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: context.localizedStyle(
                  theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdPlaceholder extends StatelessWidget {
  const _AdPlaceholder({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : const Color(0xFFF4F6F8),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.35),
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
