import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/conversion_record.dart';
import '../repositories/currency_repository.dart';

/// Single-responsibility workflow to retrieve all prior locally-saved conversions.
class GetHistory implements UseCase<List<ConversionRecord>, NoParams> {
  final CurrencyRepository repository;

  const GetHistory(this.repository);

  /// Executes the history retrieval.
  @override
  Future<Either<Failure, List<ConversionRecord>>> call(NoParams params) {
    return repository.getHistory();
  }
}
