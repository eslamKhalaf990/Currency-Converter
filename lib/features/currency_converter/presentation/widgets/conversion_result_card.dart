import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Note: Expecting localization generator to be available/configured
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/theme/dimens.dart';
import '../bloc/converter_state.dart';
import 'app_card.dart';

class ConversionResultCard extends StatelessWidget {
  final ConverterSuccess state;

  const ConversionResultCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Convert minor units (cents) to standard decimal values for display
    final double computedResult = state.resultMinorUnits / 100.0;
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      name: state.toCurrency,
      symbol: state.toCurrency,
    );

    return AppCard(
      padding: const EdgeInsetsDirectional.all(Dimens.spacingL),
      child: Column(
        children: [
          Text(
            'Conversion Result',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Dimens.spacingM),
          Text(
            formatter.format(computedResult),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Dimens.spacingS),
          Text(
            // '${l10n.exchangeRate}: 1 ${state.fromCurrency} = ${state.rate} ${state.toCurrency}',
            'Exchange Rate: 1 ${state.fromCurrency} = ${state.rate} ${state.toCurrency}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
