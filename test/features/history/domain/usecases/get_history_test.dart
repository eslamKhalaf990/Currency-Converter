import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';
import 'package:currency_converter/features/history/domain/usecases/get_history.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late GetHistory usecase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = GetHistory(mockRepository);
  });

  final tRecords = [
    ConversionRecord(
      id: '123',
      baseCurrency: 'USD',
      targetCurrency: 'EUR',
      baseAmountCents: 1000,
      convertedAmountCents: 850,
      date: DateTime(2023),
    ),
  ];

  group('GetHistory', () {
    test('should get history from the repository', () async {
      when(() => mockRepository.getHistory())
          .thenAnswer((_) async => Right(tRecords));

      final result = await usecase(NoParams());

      expect(result, Right(tRecords));
      verify(() => mockRepository.getHistory()).called(1);
    });

    test('should return Failure on error', () async {
      when(() => mockRepository.getHistory())
          .thenAnswer((_) async => const Left(CacheFailure('Cache Error')));

      final result = await usecase(NoParams());

      expect(result, const Left(CacheFailure('Cache Error')));
    });
  });
}
