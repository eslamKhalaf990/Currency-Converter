import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/currency_repository.dart';

/// Single-responsibility workflow to permanently delete a single record from local history.
class DeleteHistoryEntry implements UseCase<void, String> {
  final CurrencyRepository repository;

  const DeleteHistoryEntry(this.repository);

  /// Executes the deletion against the repository using the record's unique ID.
  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteHistoryEntry(id);
  }
}
