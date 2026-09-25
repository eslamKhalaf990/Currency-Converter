import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversion_record.dart';
import '../repositories/currency_repository.dart';

class GetHistory {
  final CurrencyRepository repository;

  const GetHistory(this.repository);

  Future<Either<Failure, List<ConversionRecord>>> call() {
    return repository.getHistory();
  }
}
