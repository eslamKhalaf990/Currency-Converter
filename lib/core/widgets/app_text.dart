import 'package:flutter/material.dart';

enum AppTextStyle {
  headlineLarge,
  headlineMedium,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle styleType;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.styleType = AppTextStyle.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    TextStyle? baseStyle;
    switch (styleType) {
      case AppTextStyle.headlineLarge:
        baseStyle = textTheme.headlineLarge;
        break;
      case AppTextStyle.headlineMedium:
        baseStyle = textTheme.headlineMedium;
        break;
      case AppTextStyle.titleLarge:
        baseStyle = textTheme.titleLarge;
        break;
      case AppTextStyle.titleMedium:
        baseStyle = textTheme.titleMedium;
        break;
      case AppTextStyle.bodyLarge:
        baseStyle = textTheme.bodyLarge;
        break;
      case AppTextStyle.bodyMedium:
        baseStyle = textTheme.bodyMedium;
        break;
      case AppTextStyle.bodySmall:
        baseStyle = textTheme.bodySmall;
        break;
    }

    if (color != null || fontWeight != null) {
      baseStyle = baseStyle?.copyWith(color: color, fontWeight: fontWeight);
    }

    return Text(
      text,
      style: baseStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
