import 'package:dartz/dartz.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/converter/domain/entities/exchange_rate.dart';

abstract class ConverterRepository {
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates(String baseCurrency);
  Future<Either<Failure, Map<String, String>>> getCurrencies();
}
