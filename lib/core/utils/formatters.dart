import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String formatCurrencyAmount(double amount) {
    final formatter = NumberFormat.currency(
      customPattern: '#,##0.00',
      decimalDigits: amount.truncateToDouble() == amount ? 0 : 2,
      symbol: '',
    );
    return formatter.format(amount).trim();
  }

  static String getCurrencySymbol(String currencyCode) {
    return NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
  }

  static String formatHistoryDate(DateTime date, String locale) {
    // Requirements: "sep 15, 2026, 0442 PM format"
    // Using hh:mm a for standard readability (04:42 PM)
    return DateFormat("MMM d, yyyy, hh:mm a", locale).format(date);
  }
}
