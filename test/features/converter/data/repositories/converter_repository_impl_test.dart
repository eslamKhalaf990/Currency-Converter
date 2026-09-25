import 'package:currency_converter/features/converter/data/datasources/converter_local_data_source.dart';
import 'package:currency_converter/features/converter/data/datasources/converter_remote_data_source.dart';
import 'package:currency_converter/features/converter/data/repositories/converter_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/converter/data/models/exchange_rate_model.dart';

class MockRemoteDataSource extends Mock implements ConverterRemoteDataSource {}

class MockLocalDataSource extends Mock implements ConverterLocalDataSource {}

void main() {
  late ConverterRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = ConverterRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tBaseCurrency = 'USD';
  final tExchangeRateModels = [
    ExchangeRateModel(
      baseCurrency: 'USD',
      targetCurrency: 'EUR',
      rate: Decimal.parse('0.85'),
    ),
  ];

  group('getExchangeRates', () {
    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getExchangeRates(any()))
          .thenAnswer((_) async => tExchangeRateModels);
      when(() => mockLocalDataSource.cacheExchangeRates(any(), any()))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repository.getExchangeRates(tBaseCurrency);

      // assert
      verify(() => mockRemoteDataSource.getExchangeRates(tBaseCurrency));
      expect(result, Right(tExchangeRateModels));
    });

    test('should return cached data when remote call throws DioException (Network Error)', () async {
      // arrange
      when(() => mockRemoteDataSource.getExchangeRates(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      when(() => mockLocalDataSource.getCachedExchangeRates(any()))
          .thenAnswer((_) async => tExchangeRateModels);

      // act
      final result = await repository.getExchangeRates(tBaseCurrency);

      // assert
      verify(() => mockRemoteDataSource.getExchangeRates(tBaseCurrency));
      verify(() => mockLocalDataSource.getCachedExchangeRates(tBaseCurrency));
      expect(result, Right(tExchangeRateModels));
    });

    test(
      'should return NetworkFailure when offline fallback also fails',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getExchangeRates(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );
        when(() => mockLocalDataSource.getCachedExchangeRates(any()))
            .thenThrow(HiveError('No cached rates'));

        // act
        final result = await repository.getExchangeRates(tBaseCurrency);

        // assert
        expect(
          result,
          const Left(
            NetworkFailure('Network Error and no offline cache available.'),
          ),
        );
      },
    );
  });
}
