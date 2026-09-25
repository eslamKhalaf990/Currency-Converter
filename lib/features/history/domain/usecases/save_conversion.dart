import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';

/// Single-responsibility workflow to persist a newly calculated conversion record into history.
class SaveConversion implements UseCase<void, ConversionRecord> {
  final HistoryRepository repository;

  const SaveConversion(this.repository);

  /// Executes the save operation.
  @override
  Future<Either<Failure, void>> call(ConversionRecord record) {
    return repository.saveConversion(record);
  }
}
