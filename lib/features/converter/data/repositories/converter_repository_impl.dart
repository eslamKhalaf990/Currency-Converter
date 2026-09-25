import 'package:dartz/dartz.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/repository/base_repository.dart';
import 'package:currency_converter/features/converter/domain/entities/exchange_rate.dart';
import 'package:currency_converter/features/converter/domain/repositories/converter_repository.dart';
import 'package:currency_converter/features/converter/data/datasources/converter_local_data_source.dart';
import 'package:currency_converter/features/converter/data/datasources/converter_remote_data_source.dart';
import 'package:currency_converter/features/converter/data/models/exchange_rate_model.dart';

class ConverterRepositoryImpl extends BaseRepository implements ConverterRepository {
  final ConverterRemoteDataSource remoteDataSource;
  final ConverterLocalDataSource localDataSource;

  ConverterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates(String baseCurrency) {
    return handleNetworkCall<List<ExchangeRateModel>, List<ExchangeRate>>(
      call: () => remoteDataSource.getExchangeRates(baseCurrency),
      cacheSave: (rates) => localDataSource.cacheExchangeRates(baseCurrency, rates),
      cacheFetch: () => localDataSource.getCachedExchangeRates(baseCurrency),
      mapper: (data) => data,
    );
  }

  @override
  Future<Either<Failure, Map<String, String>>> getCurrencies() {
    return handleNetworkCall<Map<String, String>, Map<String, String>>(
      call: () => remoteDataSource.getCurrencies(),
      mapper: (data) => data,
    );
  }
}
