import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';

/// Single-responsibility workflow to retrieve all prior locally-saved conversions.
class GetHistory implements UseCase<List<ConversionRecord>, NoParams> {
  final HistoryRepository repository;

  const GetHistory(this.repository);

  /// Executes the history retrieval.
  @override
  Future<Either<Failure, List<ConversionRecord>>> call(NoParams params) {
    return repository.getHistory();
  }
}
