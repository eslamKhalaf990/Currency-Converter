import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';
import 'package:currency_converter/features/history/domain/usecases/save_conversion.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

class FakeConversionRecord extends Fake implements ConversionRecord {}

void main() {
  late SaveConversion usecase;
  late MockHistoryRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeConversionRecord());
  });

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = SaveConversion(mockRepository);
  });

  final tRecord = ConversionRecord(
    id: '123',
    baseCurrency: 'USD',
    targetCurrency: 'EUR',
    baseAmountCents: 1000,
    convertedAmountCents: 850,
    date: DateTime(2023),
  );

  group('SaveConversion', () {
    test('should save to the repository', () async {
      when(() => mockRepository.saveConversion(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tRecord);

      expect(result, const Right(null));
      verify(() => mockRepository.saveConversion(tRecord)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure on error', () async {
      when(() => mockRepository.saveConversion(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Cache Error')));

      final result = await usecase(tRecord);

      expect(result, const Left(CacheFailure('Cache Error')));
    });
  });
}
