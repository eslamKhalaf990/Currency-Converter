import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/core/utils/date_utils.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_bloc.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_event.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_state.dart';
import 'package:currency_converter/core/widgets/app_container.dart';
import 'package:currency_converter/features/history/presentation/widgets/history_row_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
      ),
      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsetsDirectional.all(Dimens.spacingM),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: switch (state) {
                HistoryInitial() || HistoryLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                HistoryError() => Center(
                  child: Text(
                    'Failed to load history.',
                    style: textTheme.bodyLarge,
                  ),
                ),
                HistoryLoaded(:final records) =>
                  records.isEmpty
                      ? Center(
                          child: Text(
                            'No conversion history available.',
                            style: textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : _buildHistoryList(context, records, theme),
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<ConversionRecord> records,
    ThemeData theme,
  ) {
    // Sort descending
    final sortedRecords = List<ConversionRecord>.from(records)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Grouping
    final Map<String, List<ConversionRecord>> groupedData = {};
    for (final record in sortedRecords) {
      final key = AppDateUtils.getRelativeGroupingKey(record.date);
      groupedData.putIfAbsent(key, () => []).add(record);
    }

    final List<Widget> listItems = [
      Padding(
        padding: const EdgeInsetsDirectional.only(bottom: Dimens.spacingXL),
        child: Text('Converting History', style: theme.textTheme.headlineLarge),
      ),
    ];

    for (final entry in groupedData.entries) {
      listItems.add(
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: Dimens.spacingM),
          child: Text(entry.key, style: theme.textTheme.titleMedium),
        ),
      );

      listItems.add(
        AppContainer(
          margin: const EdgeInsetsDirectional.only(bottom: Dimens.spacingXL),
          padding: EdgeInsetsDirectional.zero,
          color: theme
              .colorScheme
              .surfaceContainerHigh, // Uses neutral grey from theme
          hasShadow: false,
          clipBehavior: Clip.antiAlias, // Ensures internal Dismissible gets clipped on corners
          child: Column(
            children: entry.value.map((record) {
              return HistoryRowItem(
                record: record,
                onDismissed: () {
                  context.read<HistoryBloc>().add(DeleteHistoryItem(record.id));
                },
              );
            }).toList(),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: Dimens.spacingL,
        vertical: Dimens.spacingS,
      ),
      children: listItems,
    );
  }
}
