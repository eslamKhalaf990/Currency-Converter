import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/conversion_record.dart';
import '../repositories/currency_repository.dart';

/// Single-responsibility workflow to persist a newly calculated conversion record into history.
class SaveConversion implements UseCase<void, ConversionRecord> {
  final CurrencyRepository repository;

  const SaveConversion(this.repository);

  /// Executes the save operation.
  @override
  Future<Either<Failure, void>> call(ConversionRecord record) {
    return repository.saveConversion(record);
  }
}
