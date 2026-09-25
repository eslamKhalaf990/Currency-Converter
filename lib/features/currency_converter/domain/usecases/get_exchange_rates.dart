import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exchange_rate.dart';
import '../repositories/currency_repository.dart';

/// Request latest network exchange rates for a given currency while preventing upstream empty-string requests.
class GetExchangeRates implements UseCase<List<ExchangeRate>, String> {
  final CurrencyRepository repository;

  const GetExchangeRates(this.repository);

  /// Executes the request, failing fast if the supplied base currency is blank to save a network call.
  @override
  Future<Either<Failure, List<ExchangeRate>>> call(String baseCurrency) async {
    if (baseCurrency.trim().isEmpty) {
      return const Left(ValidationFailure('Base currency cannot be empty'));
    }
    return repository.getExchangeRates(baseCurrency);
  }
}
