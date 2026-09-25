import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_state.dart';
import 'package:currency_converter/core/widgets/app_button.dart';

class SubmitConvertButton extends StatelessWidget {
  final VoidCallback onConvert;

  const SubmitConvertButton({super.key, required this.onConvert});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConverterBloc, ConverterState>(
      builder: (context, state) {
        return AppButton(
          onPressed: onConvert,
          text: 'Convert',
          isLoading: switch (state) {
            ConverterLoading() => true,
            _ => false,
          },
        );
      },
    );
  }
}
