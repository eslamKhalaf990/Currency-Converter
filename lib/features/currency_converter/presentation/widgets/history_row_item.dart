import 'package:flutter/material.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/conversion_record.dart';

class HistoryRowItem extends StatelessWidget {
  final ConversionRecord record;
  final VoidCallback onDismissed;

  const HistoryRowItem({
    super.key,
    required this.record,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();

    final double baseAmount = record.baseAmountCents / 100.0;
    final double convertedAmount = record.convertedAmountCents / 100.0;

    final baseSymbol = AppFormatters.getCurrencySymbol(record.baseCurrency);
    final targetSymbol = AppFormatters.getCurrencySymbol(record.targetCurrency);
    final dateFormatted = AppFormatters.formatHistoryDate(record.date, locale);

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Dimens.spacingL),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: Dimens.spacingM,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From ${record.baseCurrency} to ${record.targetCurrency}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(dateFormatted, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: Dimens.spacingS),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$baseSymbol ${AppFormatters.formatCurrencyAmount(baseAmount)}',
                  style: theme.textTheme.bodyMedium,
                ),
                Container(
                  width: 1,
                  height: 16,
                  color: theme.colorScheme.outlineVariant,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Text(
                  '$targetSymbol ${AppFormatters.formatCurrencyAmount(convertedAmount)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
