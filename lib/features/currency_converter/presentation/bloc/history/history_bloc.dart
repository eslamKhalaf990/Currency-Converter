import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/delete_history_entry.dart';
import '../../../domain/usecases/get_history.dart';
import 'history_event.dart';
import 'history_state.dart';

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
    final result = await deleteHistoryEntry(event.id);
    result.fold((failure) => emit(HistoryError(failure.message)), (_) {
      // If state is HistoryLoaded we could optimistically update it,
      // but triggering a reload is safer and consistent for simpler tasks.
      add(const LoadHistory());
    });
  }
}
