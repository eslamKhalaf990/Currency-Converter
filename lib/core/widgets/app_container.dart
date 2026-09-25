import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/dimens.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool hasShadow;
  final double? radius;
  final bool isCircle;
  final Clip clipBehavior;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.hasShadow = false,
    this.radius,
    this.isCircle = false,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsetsDirectional.all(Dimens.spacingM),
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: color ?? colorScheme.surface,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : BorderRadius.circular(radius ?? Dimens.radiusL),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: colorScheme.onSurface.withValues(alpha: 0.04),
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
