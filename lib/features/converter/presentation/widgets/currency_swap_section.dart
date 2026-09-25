import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/core/widgets/app_container.dart';
import 'package:currency_converter/features/converter/presentation/widgets/currency_dropdown.dart';
import 'package:currency_converter/features/converter/presentation/widgets/currency_dropdown_skeleton.dart';

class CurrencySwapSection extends StatelessWidget {
  final ValueNotifier<String> fromCurrency;
  final ValueNotifier<String> toCurrency;
  final List<String> supportedCurrencies;
  final bool isLoading;

  const CurrencySwapSection({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.supportedCurrencies,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return IntrinsicHeight(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: isLoading
                    ? const CurrencyDropdownSkeleton()
                    : CurrencyDropdown(
                        title: 'From',
                        value: fromCurrency.value,
                        items: supportedCurrencies,
                        onChanged: (value) {
                          if (value != null) fromCurrency.value = value;
                        },
                      ),
              ),
              const SizedBox(width: Dimens.spacingM),
              Expanded(
                child: isLoading
                    ? const CurrencyDropdownSkeleton()
                    : CurrencyDropdown(
                        title: 'To',
                        value: toCurrency.value,
                        items: supportedCurrencies,
                        onChanged: (value) {
                          if (value != null) toCurrency.value = value;
                        },
                      ),
              ),
            ],
          ),
          if (!isLoading)
            AppContainer(
              color: theme.scaffoldBackgroundColor, // Inherits configured background perfectly
              isCircle: true,
              padding: const EdgeInsets.all(Dimens.spacingS),
              child: InkWell(
                onTap: () {
                  final temp = fromCurrency.value;
                  fromCurrency.value = toCurrency.value;
                  toCurrency.value = temp;
                },
                borderRadius: BorderRadius.circular(Dimens.radiusL),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.spacingXS),
                  child: Icon(
                    Icons.sync_alt,
                    color: colorScheme.onSurface,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
