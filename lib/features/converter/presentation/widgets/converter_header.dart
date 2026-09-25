import 'package:flutter/material.dart';

import 'package:currency_converter/core/widgets/app_text.dart';

class ConverterHeader extends StatelessWidget {
  const ConverterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppText('Convert', styleType: AppTextStyle.headlineLarge);
  }
}
