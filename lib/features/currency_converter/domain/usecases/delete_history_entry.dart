import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/currency_repository.dart';

class DeleteHistoryEntry {
  final CurrencyRepository repository;

  const DeleteHistoryEntry(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteHistoryEntry(id);
  }
}
