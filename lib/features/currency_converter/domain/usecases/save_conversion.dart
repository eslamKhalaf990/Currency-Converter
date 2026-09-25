import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversion_record.dart';
import '../repositories/currency_repository.dart';

class SaveConversion {
  final CurrencyRepository repository;

  const SaveConversion(this.repository);

  Future<Either<Failure, void>> call(ConversionRecord record) {
    return repository.saveConversion(record);
  }
}
