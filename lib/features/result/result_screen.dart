import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
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
      (l10n.energyCharges, result.energyCharges),
      (l10n.fixedCharges, result.fixedCharges),
      (l10n.gst, result.gst),
      (l10n.fpa, result.fpa),
      (l10n.electricityDuty, result.electricityDuty),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.estimatedBill),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.totalEstimatedBill,
                        style: context.localizedStyle(
                          theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.pkr} ${CurrencyFormatter.format(result.total)}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${result.units} ${l10n.units}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        for (final (label, amount) in breakdownRows)
                          _BreakdownRow(
                            label: label,
                            amount: amount,
                            localizedLabel: context.isUrdu,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: theme.colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.disclaimer,
                          style: context.localizedStyle(
                            theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.ratesLastUpdated(
                    DateFormatter.formatIsoDate(result.lastUpdated),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (result.ratesStale) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.ratesMayBeOutdated,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.share_rounded,
                        label: l10n.share,
                        onTap: () => _share(context, result),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.flag_outlined,
                        label: l10n.reportIssue,
                        onTap: () => showReportIssueSheet(context, result),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.refresh_rounded,
                        label: l10n.calculateAgain,
                        onTap: () => context.go('/units'),
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
    required this.localizedLabel,
  });

  final String label;
  final double amount;
  final bool localizedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: localizedLabel
                  ? Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontFamily: null)
                  : theme.textTheme.bodyLarge,
            ),
          ),
          Text(
            '${context.l10n.pkr} ${CurrencyFormatter.format(amount)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.dividerTheme.color ?? Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: context.localizedStyle(
                  theme.textTheme.labelMedium,
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
    return Container(
      width: double.infinity,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade300,
          ),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
      ),
    );
  }
}
