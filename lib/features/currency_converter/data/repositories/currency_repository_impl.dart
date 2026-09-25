import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repository/base_repository.dart';
import '../../domain/entities/conversion_record.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/conversion_record_model.dart';
import '../models/exchange_rate_model.dart';

/// Real-world implementation bridging the contract boundaries set by the logical Domain.
/// Inherits BaseRepository to strip all try-catch bloat out of feature logic,
/// supplying Higher-Order Functions instead.
class CurrencyRepositoryImpl extends BaseRepository
    implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates(
    String baseCurrency,
  ) {
    return handleNetworkCall<List<ExchangeRateModel>, List<ExchangeRate>>(
      call: () => remoteDataSource.getExchangeRates(baseCurrency),
      cacheSave: (rates) =>
          localDataSource.cacheExchangeRates(baseCurrency, rates),
      cacheFetch: () => localDataSource.getCachedExchangeRates(baseCurrency),
      mapper: (data) =>
          data, // Models perfectly extend entities, so direct pass-through
    );
  }

  @override
  Future<Either<Failure, Map<String, String>>> getCurrencies() {
    return handleNetworkCall<Map<String, String>, Map<String, String>>(
      call: () => remoteDataSource.getCurrencies(),
      mapper: (data) => data,
    );
  }

  @override
  Future<Either<Failure, void>> saveConversion(ConversionRecord record) {
    return handleLocalAction<void>(
      action: () async {
        final model = ConversionRecordModel(
          id: record.id,
          baseCurrency: record.baseCurrency,
          targetCurrency: record.targetCurrency,
          baseAmountCents: record.baseAmountCents,
          convertedAmountCents: record.convertedAmountCents,
          date: record.date,
        );
        await localDataSource.saveConversion(model);
      },
    );
  }

  @override
  Future<Either<Failure, List<ConversionRecord>>> getHistory() {
    return handleLocalAction<List<ConversionRecord>>(
      action: () => localDataSource.getHistory(),
    );
  }

  @override
  Future<Either<Failure, void>> deleteHistoryEntry(String id) {
    return handleLocalAction<void>(
      action: () => localDataSource.deleteHistoryEntry(id),
    );
  }
}
