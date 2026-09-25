import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:currency_picker/currency_picker.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_state.dart';
import 'package:currency_converter/core/widgets/app_container.dart';

class ConversionResultCard extends StatelessWidget {
  final ConverterSuccess state;

  const ConversionResultCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Convert minor units (cents) to standard decimal values for display
    final double computedResult = state.resultMinorUnits / 100.0;

    final CurrencyService currencyService = CurrencyService();
    final Currency? fromCur = currencyService.findByCode(state.fromCurrency);
    final Currency? toCur = currencyService.findByCode(state.toCurrency);

    final toSymbol = toCur?.symbol ?? state.toCurrency;

    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      name: state.toCurrency,
      symbol: toSymbol,
    );

    return AppContainer(
      hasShadow: true,
      padding: const EdgeInsetsDirectional.all(Dimens.spacingL),
      child: Column(
        children: [
          Text(
            'Conversion Result',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Dimens.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (toCur != null && toCur.flag != null && !toCur.isFlagImage)
                Text(
                  '${CurrencyUtils.currencyToEmoji(toCur)} ',
                  style: textTheme.headlineMedium,
                ),
              Text(
                formatter.format(computedResult),
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (toCur != null) ...[
            const SizedBox(height: Dimens.spacingXS),
            Text(
              toCur.name,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Dimens.spacingS),
          Text(
            'Exchange Rate: 1 ${fromCur?.symbol ?? state.fromCurrency} = ${state.rate} ${toCur?.symbol ?? state.toCurrency}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (state.cachedUpdatedAt != null) ...[
            const SizedBox(height: Dimens.spacingL),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.spacingS,
                horizontal: Dimens.spacingM,
              ),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(Dimens.radiusS),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.offline_bolt,
                    color: colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: Dimens.spacingS),
                  Expanded(
                    child: Text(
                      '⚠️ You are offline. Showing cached rates from ${DateFormat.yMd().add_jm().format(state.cachedUpdatedAt!)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
