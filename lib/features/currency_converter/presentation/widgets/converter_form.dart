import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_currencies.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
import 'app_button.dart';
import 'app_text_field.dart';
import 'currency_dropdown.dart';

class ConverterForm extends HookWidget {
  const ConverterForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Stateless reactive setup using flutter_hooks
    final amountController = useTextEditingController();
    final fromCurrency = useState('EUR');
    final toCurrency = useState('USD');
    final amountError = useState<String?>(null);

    // Fetch currencies dynamically
    final supportedCurrencies = useState<List<String>>([
      'EUR',
      'USD',
    ]); // Default fallback
    final isLoadingCurrencies = useState(true);

    useEffect(() {
      sl<GetCurrencies>()(const NoParams()).then((result) {
        result.fold(
          (failure) {
            // In case of a network failure, we leave it as the fallback
            isLoadingCurrencies.value = false;
          },
          (currenciesMap) {
            final keys = currenciesMap.keys.toList();
            // Optional: Ensure EUR and USD are present because they are the default selected.
            // If they are missing from the API results for some reason, we can add them to prevent dropdown crash.
            if (!keys.contains('EUR')) keys.insert(0, 'EUR');
            if (!keys.contains('USD')) keys.insert(1, 'USD');

            supportedCurrencies.value = keys;
            isLoadingCurrencies.value = false;
          },
        );
      });
      return null;
    }, const []);

    void onConvert() {
      FocusScope.of(context).unfocus();
      final amountStr = amountController.text.trim();

      if (amountStr.isEmpty) {
        amountError.value = 'Please enter an amount';
        return;
      }

      // Check if any alphabetical character or invalid symbol is typed
      final invalidCharsRegex = RegExp(r'[^\d.,]');
      if (invalidCharsRegex.hasMatch(amountStr)) {
        amountError.value =
            'Please enter numbers only. Characters are not allowed.';
        return;
      }

      final amountValue = double.tryParse(amountStr.replaceAll(',', ''));
      if (amountValue == null) {
        amountError.value = 'Please enter a valid number format';
        return;
      }

      if (amountValue <= 0) {
        amountError.value = 'Amount must be greater than zero';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Convert',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: Dimens.spacingM),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                amountController.clear();
                amountError.value = null;
                fromCurrency.value = 'EUR';
                toCurrency.value = 'USD';
              },
              icon: const Icon(Icons.refresh, color: Colors.black, size: 28),
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingL),
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: isLoadingCurrencies.value
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(
                                Dimens.radiusM,
                              ),
                            ),
                          )
                        : CurrencyDropdown(
                            title: 'From',
                            value: fromCurrency.value,
                            items: supportedCurrencies.value,
                            onChanged: (value) {
                              if (value != null) fromCurrency.value = value;
                            },
                          ),
                  ),
                  const SizedBox(width: Dimens.spacingM),
                  Expanded(
                    child: isLoadingCurrencies.value
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEBEB),
                              borderRadius: BorderRadius.circular(
                                Dimens.radiusM,
                              ),
                            ),
                          )
                        : CurrencyDropdown(
                            title: 'To',
                            value: toCurrency.value,
                            items: supportedCurrencies.value,
                            onChanged: (value) {
                              if (value != null) toCurrency.value = value;
                            },
                          ),
                  ),
                ],
              ),
              if (!isLoadingCurrencies.value)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor, // match parent background
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      final temp = fromCurrency.value;
                      fromCurrency.value = toCurrency.value;
                      toCurrency.value = temp;
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.sync_alt,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: Dimens.spacingL),
        AppTextField(
          controller: amountController,
          hintText: 'Amount', // replace with l10n.amountHint
          errorText: amountError.value,
          suffixText: fromCurrency.value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            if (amountError.value != null) {
              amountError.value = null;
            }
          },
        ),
        const SizedBox(height: Dimens.spacingM),
        BlocBuilder<ConverterBloc, ConverterState>(
          builder: (context, state) {
            // Leveraging Dart 3 exact pattern matching
            return AppButton(
              onPressed: onConvert,
              text: 'Convert', // replace with l10n.convertButton
              isLoading: switch (state) {
                ConverterLoading() => true,
                _ => false,
              },
            );
          },
        ),
      ],
    );
  }
}
