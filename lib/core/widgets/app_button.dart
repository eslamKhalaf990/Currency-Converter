import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/dimens.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: Dimens.spacingM,
          horizontal: Dimens.spacingL,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusL),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              width: Dimens.spacingL,
              height: Dimens.spacingL,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onPrimary,
                ),
              ),
            )
          : Text(
              text,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
    );
  }
}
