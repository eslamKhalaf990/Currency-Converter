import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/core/widgets/app_container.dart';
import 'package:currency_converter/core/widgets/app_text.dart';

class CurrencyDropdown extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final CurrencyService currencyService = CurrencyService();
    final Currency? currency = currencyService.findByCode(value);

    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
      ),
      itemBuilder: (context) {
        return items.map((String curCode) {
          final curInfo = currencyService.findByCode(curCode);
          final hasFlag =
              curInfo != null && curInfo.flag != null && !curInfo.isFlagImage;
          return PopupMenuItem<String>(
            value: curCode,
            child: Row(
              children: [
                if (hasFlag) ...[
                  AppText(
                    CurrencyUtils.currencyToEmoji(curInfo),
                    styleType: AppTextStyle.titleMedium,
                  ),
                  const SizedBox(width: Dimens.spacingS),
                ],
                AppText(
                  curCode,
                  styleType: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.bold,
                ),
                if (curInfo != null) ...[
                  const SizedBox(width: Dimens.spacingS),
                  Expanded(
                    child: AppText(
                      '- ${curInfo.name}',
                      styleType: AppTextStyle.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList();
      },
      child: AppContainer(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: Dimens.spacingL,
          horizontal: Dimens.spacingM,
        ),
        color: colorScheme.surfaceContainerHigh,
        radius: Dimens.radiusM,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              title,
              styleType: AppTextStyle.bodyMedium,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: Dimens.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currency != null &&
                    currency.flag != null &&
                    !currency.isFlagImage) ...[
                  AppText(
                    CurrencyUtils.currencyToEmoji(currency),
                    styleType: AppTextStyle.headlineLarge,
                  ),
                  const SizedBox(width: Dimens.spacingS),
                ],
                AppText(value, styleType: AppTextStyle.headlineLarge),
              ],
            ),
            if (currency != null) ...[
              const SizedBox(height: Dimens.spacingXS),
              AppText(
                '${currency.name} - ${currency.symbol}',
                styleType: AppTextStyle.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: Dimens.spacingS),
            Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
