import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversion_record.dart';
import '../entities/exchange_rate.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates(
    String baseCurrency,
  );

  Future<Either<Failure, void>> saveConversion(ConversionRecord record);

  Future<Either<Failure, List<ConversionRecord>>> getHistory();

  Future<Either<Failure, void>> deleteHistoryEntry(String id);
}
