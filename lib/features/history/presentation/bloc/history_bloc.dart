import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/history/domain/usecases/delete_history_entry.dart';
import 'package:currency_converter/features/history/domain/usecases/get_history.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_event.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistory getHistory;
  final DeleteHistoryEntry deleteHistoryEntry;

  HistoryBloc({required this.getHistory, required this.deleteHistoryEntry})
    : super(const HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<DeleteHistoryItem>(_onDeleteHistoryItem);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    final result = await getHistory(const NoParams());

    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (records) => emit(HistoryLoaded(records)),
    );
  }

  Future<void> _onDeleteHistoryItem(
    DeleteHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    HistoryLoaded? previousState;
    
    // Optimistic update for better UX
    if (state is HistoryLoaded) {
      previousState = state as HistoryLoaded;
      final updatedRecords = previousState.records
          .where((record) => record.id != event.id)
          .toList();
      emit(HistoryLoaded(updatedRecords));
    }

    final result = await deleteHistoryEntry(event.id);
    result.fold(
      (failure) {
        emit(HistoryError(failure.message));
        if (previousState != null) {
          // Revert back on failure
          emit(previousState);
        }
      },
      (_) {
        // Deletion successful, state already updated optimistically
      },
    );
  }
}
