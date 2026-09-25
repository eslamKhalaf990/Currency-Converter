import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/core/utils/formatters.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';

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
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();

    final double baseAmount = record.baseAmountCents / 100.0;
    final double convertedAmount = record.convertedAmountCents / 100.0;

    final baseSymbol = AppFormatters.getCurrencySymbol(record.baseCurrency);
    final targetSymbol = AppFormatters.getCurrencySymbol(record.targetCurrency);
    final dateFormatted = AppFormatters.formatHistoryDate(record.date, locale);

    final CurrencyService currencyService = CurrencyService();
    final Currency? baseCur = currencyService.findByCode(record.baseCurrency);
    final Currency? targetCur = currencyService.findByCode(
      record.targetCurrency,
    );

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: Dimens.spacingL),
        color: colorScheme.error,
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimens.spacingL,
          vertical: Dimens.spacingM,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (baseCur != null &&
                          baseCur.flag != null &&
                          !baseCur.isFlagImage)
                        Text(
                          '${CurrencyUtils.currencyToEmoji(baseCur)} ',
                          style: textTheme.bodyLarge,
                        ),
                      Text(
                        record.baseCurrency,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Dimens.spacingXS,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (targetCur != null &&
                          targetCur.flag != null &&
                          !targetCur.isFlagImage)
                        Text(
                          '${CurrencyUtils.currencyToEmoji(targetCur)} ',
                          style: textTheme.bodyLarge,
                        ),
                      Text(
                        record.targetCurrency,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (baseCur != null && targetCur != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimens.spacingXS),
                      child: Text(
                        '${baseCur.name} to ${targetCur.name}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  const SizedBox(height: Dimens.spacingS),
                  Text(dateFormatted, style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: Dimens.spacingS),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$baseSymbol ${AppFormatters.formatCurrencyAmount(baseAmount)}',
                  style: textTheme.bodyMedium,
                ),
                Container(
                  width: 1,
                  height: 16,
                  color: colorScheme.outlineVariant,
                  margin: const EdgeInsetsDirectional.symmetric(
                    horizontal: Dimens.spacingM,
                  ),
                ),
                Text(
                  '$targetSymbol ${AppFormatters.formatCurrencyAmount(convertedAmount)}',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
