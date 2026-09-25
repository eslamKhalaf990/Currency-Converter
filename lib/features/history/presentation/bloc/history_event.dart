import 'package:equatable/equatable.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class DeleteHistoryItem extends HistoryEvent {
  final String id;

  const DeleteHistoryItem(this.id);

  @override
  List<Object?> get props => [id];
}
