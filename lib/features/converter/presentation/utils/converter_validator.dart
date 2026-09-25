class ConverterValidator {
  static String? validateAmount(String amountStr) {
    if (amountStr.isEmpty) return 'Please enter an amount';

    final invalidCharsRegex = RegExp(r'[^\d.,]');
    if (invalidCharsRegex.hasMatch(amountStr)) {
      return 'Please enter numbers only. Characters are not allowed.';
    }

    final amountValue = double.tryParse(amountStr.replaceAll(',', ''));
    if (amountValue == null) return 'Please enter a valid number format';

    if (amountValue <= 0) return 'Amount must be greater than zero';

    return null;
  }
}
