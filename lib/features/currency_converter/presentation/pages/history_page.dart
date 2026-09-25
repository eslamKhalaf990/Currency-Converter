import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/conversion_record.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../bloc/history/history_state.dart';
import '../widgets/app_card.dart';
import '../widgets/history_row_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                HistoryError() => const Center(
                  child: Text('Failed to load history.'),
                ),
                HistoryLoaded(:final records) =>
                  records.isEmpty
                      ? const Center(
                          child: Text(
                            'No conversion history available.',
                            style: TextStyle(fontSize: 16),
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
        padding: const EdgeInsets.only(bottom: Dimens.spacingXL),
        child: Text('Converting History', style: theme.textTheme.headlineLarge),
      ),
    ];

    for (final entry in groupedData.entries) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.spacingM),
          child: Text(entry.key, style: theme.textTheme.titleMedium),
        ),
      );

      listItems.add(
        AppCard(
          margin: const EdgeInsets.only(bottom: Dimens.spacingXL),
          padding: EdgeInsets.zero,
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
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacingL,
        vertical: Dimens.spacingS,
      ),
      children: listItems,
    );
  }
}
