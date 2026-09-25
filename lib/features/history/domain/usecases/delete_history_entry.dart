import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';

/// Single-responsibility workflow to permanently delete a single record from local history.
class DeleteHistoryEntry implements UseCase<void, String> {
  final HistoryRepository repository;

  const DeleteHistoryEntry(this.repository);

  /// Executes the deletion against the repository using the record's unique ID.
  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteHistoryEntry(id);
  }
}
