import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/tariff_model.dart';
import '../../shared/extensions/localized_text.dart';

Future<void> showReportIssueSheet(
  BuildContext context,
  BillBreakdown result,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _ReportIssueSheet(result: result),
  );
}

class _ReportIssueSheet extends StatefulWidget {
  const _ReportIssueSheet({required this.result});
  final BillBreakdown result;

  @override
  State<_ReportIssueSheet> createState() => _ReportIssueSheetState();
}

class _ReportIssueSheetState extends State<_ReportIssueSheet> {
  final _actualController = TextEditingController();

  @override
  void dispose() {
    _actualController.dispose();
    super.dispose();
  }

  String _buildMessage(BuildContext context) {
    final l10n = context.l10n;
    final actual = _actualController.text.trim().isEmpty
        ? 'N/A'
        : _actualController.text.trim();
    return l10n.feedbackWhatsappMessage(
      widget.result.disco,
      widget.result.category.key,
      widget.result.units.toString(),
      CurrencyFormatter.format(widget.result.total),
      actual,
    );
  }

  Future<void> _sendWhatsapp() async {
    final message = Uri.encodeComponent(_buildMessage(context));
    final uri = Uri.parse(
      'https://wa.me/${AppConstants.feedbackWhatsappNumber}?text=$message',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _sendEmail() async {
    final l10n = context.l10n;
    final subject = Uri.encodeComponent(l10n.reportIssueTitle);
    final body = Uri.encodeComponent(_buildMessage(context));
    final uri = Uri.parse(
      'mailto:${AppConstants.feedbackEmail}?subject=$subject&body=$body',
    );
    await launchUrl(uri);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag_outlined,
                    color: Color(0xFFF59E0B), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reportIssueTitle,
                      style: context.localizedStyle(
                          theme.textTheme.titleLarge),
                    ),
                    Text(
                      'Help us improve the accuracy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Summary tiles
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'DISCO', value: widget.result.disco),
                _SummaryRow(
                  label: l10n.consumerCategory,
                  value: widget.result.category.key,
                ),
                _SummaryRow(
                  label: l10n.units,
                  value: '${widget.result.units} kWh',
                ),
                _SummaryRow(
                  label: l10n.estimatedBill,
                  value:
                      '${l10n.pkr} ${CurrencyFormatter.format(widget.result.total)}',
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _actualController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.actualBillOptional,
              prefixIcon: const Icon(Icons.receipt_outlined),
              hintText: 'e.g. 3,450',
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _sendWhatsapp,
            icon: const Icon(Icons.chat_rounded, size: 18),
            label: Text(l10n.sendViaWhatsapp),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _sendEmail,
            icon: const Icon(Icons.email_outlined, size: 18),
            label: Text(l10n.sendViaEmail),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}
