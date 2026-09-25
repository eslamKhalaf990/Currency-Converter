import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_event.dart';
import 'package:currency_converter/features/converter/presentation/hooks/use_currencies.dart';
import 'package:currency_converter/features/converter/presentation/utils/converter_validator.dart';
import 'package:currency_converter/features/converter/presentation/widgets/amount_input_field.dart';
import 'package:currency_converter/features/converter/presentation/widgets/converter_header.dart';
import 'package:currency_converter/features/converter/presentation/widgets/currency_swap_section.dart';
import 'package:currency_converter/features/converter/presentation/widgets/submit_convert_button.dart';

class ConverterForm extends HookWidget {
  const ConverterForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Top-Level State Initialization
    final amountController = useTextEditingController();
    final fromCurrency = useState('EUR');
    final toCurrency = useState('USD');
    final amountError = useState<String?>(null);

    // Isolated Logic Hook retrieving external business info purely
    final currenciesState = useCurrencies();
    final supportedCurrencies = currenciesState[0] as List<String>;
    final isLoadingCurrencies = currenciesState[1] as bool;

    void handleConvert() {
      FocusScope.of(context).unfocus();
      final amountStr = amountController.text.trim();

      final error = ConverterValidator.validateAmount(amountStr);
      if (error != null) {
        amountError.value = error;
        return;
      }

      amountError.value = null;
      context.read<ConverterBloc>().add(
        ConvertCurrenciesRequested(
          fromCurrency: fromCurrency.value,
          toCurrency: toCurrency.value,
          amount: amountStr,
        ),
      );
    }

    void handleReset() {
      amountController.clear();
      amountError.value = null;
      fromCurrency.value = 'EUR';
      toCurrency.value = 'USD';
    }

    // Explicit Clean Structural Hierarchy
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConverterHeader(onReset: handleReset),
        const SizedBox(height: Dimens.spacingL),
        CurrencySwapSection(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          supportedCurrencies: supportedCurrencies,
          isLoading: isLoadingCurrencies,
        ),
        const SizedBox(height: Dimens.spacingL),
        AmountInputField(
          controller: amountController,
          fromCurrency: fromCurrency.value,
          errorText: amountError.value,
          onErrorCleared: () {
            if (amountError.value != null) amountError.value = null;
          },
        ),
        const SizedBox(height: Dimens.spacingM),
        SubmitConvertButton(onConvert: handleConvert),
      ],
    );
  }
}
