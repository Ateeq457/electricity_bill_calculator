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
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.reportIssueTitle,
            style: context.localizedStyle(theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 16),
          _SummaryTile(
            label: 'DISCO',
            value: widget.result.disco,
          ),
          _SummaryTile(
            label: l10n.consumerCategory,
            value: widget.result.category.key,
          ),
          _SummaryTile(
            label: l10n.units,
            value: '${widget.result.units} kWh',
          ),
          _SummaryTile(
            label: l10n.estimatedBill,
            value: '${l10n.pkr} ${CurrencyFormatter.format(widget.result.total)}',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _actualController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.actualBillOptional,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _sendWhatsapp,
            icon: const Icon(Icons.chat_rounded),
            label: Text(l10n.sendViaWhatsapp),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _sendEmail,
            icon: const Icon(Icons.email_outlined),
            label: Text(l10n.sendViaEmail),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.65),
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
