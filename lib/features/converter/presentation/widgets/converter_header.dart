import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/core/widgets/app_text.dart';

class ConverterHeader extends StatelessWidget {
  final VoidCallback onReset;

  const ConverterHeader({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const AppText('Convert', styleType: AppTextStyle.headlineLarge),
            const SizedBox(width: Dimens.spacingM),
            ElevatedButton(
              onPressed: () {}, // Save functionality
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: Dimens.spacingM,
                ),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusL),
                ),
              ),
              child: const AppText('Save', styleType: AppTextStyle.bodyMedium),
            ),
          ],
        ),
        IconButton(
          onPressed: onReset,
          icon: Icon(Icons.refresh, color: colorScheme.onSurface, size: 28),
        ),
      ],
    );
  }
}
