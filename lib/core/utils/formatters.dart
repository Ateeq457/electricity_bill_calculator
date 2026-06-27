import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat('#,##0', 'en_US');

  static String format(double amount) => _formatter.format(amount.round());
}

class DateFormatter {
  static String formatIsoDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('d MMM yyyy').format(date);
    } catch (_) {
      return isoDate;
    }
  }
}
