import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart' as di;
import '../../../../core/theme/dimens.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_state.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../widgets/conversion_result_card.dart';
import '../widgets/converter_form.dart';
import 'history_page.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Currency Converter'), // replace with l10n.appTitle
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) =>
                        di.sl<HistoryBloc>()..add(const LoadHistory()),
                    child: const HistoryPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ConverterBloc, ConverterState>(
        listener: (context, state) {
          // Utilizing a switch expression here gracefully avoids loose type checking
          switch (state) {
            case ConverterError(:final message):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: theme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsetsDirectional.all(Dimens.spacingM),
                ),
              );
            case ConverterInitial():
            case ConverterLoading():
            case ConverterSuccess():
              break; // No UI overlay response needed
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsetsDirectional.all(Dimens.spacingL),
                children: [
                  const ConverterForm(),
                  const SizedBox(height: Dimens.spacingXL),
                  // Beautifully readable structural variance using exhaustive Dart 3 declarative switches
                  switch (state) {
                    ConverterSuccess() => ConversionResultCard(state: state),
                    ConverterInitial() ||
                    ConverterLoading() ||
                    ConverterError() => const SizedBox.shrink(),
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
