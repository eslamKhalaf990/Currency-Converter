import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/converter/domain/repositories/converter_repository.dart';

class GetCurrencies implements UseCase<Map<String, String>, NoParams> {
  final ConverterRepository repository;

  GetCurrencies(this.repository);

  @override
  Future<Either<Failure, Map<String, String>>> call(NoParams params) async {
    return await repository.getCurrencies();
  }
}
