import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/exchange_rate.dart';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/get_exchange_rates.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late GetExchangeRates usecase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    usecase = GetExchangeRates(mockRepository);
  });

  const tBaseCurrency = 'USD';
  final tExchangeRates = [
    ExchangeRate(baseCurrency: 'USD', targetCurrency: 'EUR', rate: Decimal.parse('0.85')),
  ];

  group('GetExchangeRates', () {
    test(
      'should return list of rates from the repository when valid',
      () async {
        // Arrange
        when(() => mockRepository.getExchangeRates(any()))
            .thenAnswer((_) async => Right(tExchangeRates));

        // Act
        final result = await usecase(tBaseCurrency);

        // Assert
        expect(result, Right(tExchangeRates));
        verify(() => mockRepository.getExchangeRates(tBaseCurrency)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ValidationFailure when base currency is empty',
      () async {
        // Act
        final result = await usecase('   ');

        // Assert
        expect(
          result,
          const Left(ValidationFailure('Base currency cannot be empty')),
        );
        verifyZeroInteractions(mockRepository);
      },
    );

    test(
      'should return Failure from the repository when exception occurs',
      () async {
        // Arrange
        when(() => mockRepository.getExchangeRates(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Server Error')));

        // Act
        final result = await usecase(tBaseCurrency);

        // Assert
        expect(result, const Left(ServerFailure('Server Error')));
        verify(() => mockRepository.getExchangeRates(tBaseCurrency)).called(1);
      },
    );
  });
}
