import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/dimens.dart';

class CurrencyDropdownSkeleton extends StatelessWidget {
  const CurrencyDropdownSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // We use a constant subtle base color for the skeleton placeholders
    final baseColor = colorScheme.surfaceContainerHighest.withAlpha(102);

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: Dimens.spacingL,
        horizontal: Dimens.spacingM,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(Dimens.radiusM),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShimmerBlock(baseColor, width: 40, height: 16),
          const SizedBox(height: Dimens.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShimmerBlock(baseColor,
                  width: 28, height: 28, shape: BoxShape.circle),
              const SizedBox(width: Dimens.spacingS),
              _buildShimmerBlock(baseColor, width: 60, height: 32),
            ],
          ),
          const SizedBox(height: Dimens.spacingS),
          _buildShimmerBlock(baseColor, width: 80, height: 14),
          const SizedBox(height: Dimens.spacingS),
          _buildShimmerBlock(baseColor, width: 24, height: 24),
        ],
      ),
    );
  }

  Widget _buildShimmerBlock(Color color,
      {required double width,
      required double height,
      BoxShape shape = BoxShape.rectangle}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(4) : null,
      ),
    );
  }
}
