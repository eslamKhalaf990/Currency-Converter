import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

import 'package:currency_converter/core/widgets/app_text_field.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String fromCurrency;
  final String? errorText;
  final VoidCallback onErrorCleared;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.fromCurrency,
    required this.errorText,
    required this.onErrorCleared,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'Amount', // replace with l10n.amountHint natively later
      errorText: errorText,
      suffixText:
          CurrencyService().findByCode(fromCurrency)?.symbol ?? fromCurrency,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onErrorCleared(),
    );
  }
}
