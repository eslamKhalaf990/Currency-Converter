import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exchange_rate.dart';
import '../repositories/currency_repository.dart';

class GetExchangeRates {
  final CurrencyRepository repository;

  const GetExchangeRates(this.repository);

  Future<Either<Failure, List<ExchangeRate>>> call(String baseCurrency) async {
    if (baseCurrency.trim().isEmpty) {
      return const Left(ValidationFailure('Base currency cannot be empty'));
    }
    return repository.getExchangeRates(baseCurrency);
  }
}
