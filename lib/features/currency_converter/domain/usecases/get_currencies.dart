import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/currency_repository.dart';

class GetCurrencies implements UseCase<Map<String, String>, NoParams> {
  final CurrencyRepository repository;

  GetCurrencies(this.repository);

  @override
  Future<Either<Failure, Map<String, String>>> call(NoParams params) async {
    return await repository.getCurrencies();
  }
}
