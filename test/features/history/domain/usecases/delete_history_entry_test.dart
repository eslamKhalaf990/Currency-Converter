import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/history/domain/usecases/delete_history_entry.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late DeleteHistoryEntry usecase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = DeleteHistoryEntry(mockRepository);
  });

  group('DeleteHistoryEntry', () {
    test('should delete from the repository', () async {
      when(() => mockRepository.deleteHistoryEntry(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase('123');

      expect(result, const Right(null));
      verify(() => mockRepository.deleteHistoryEntry('123')).called(1);
    });

    test('should return Failure on error', () async {
      when(() => mockRepository.deleteHistoryEntry(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Cache Error')));

      final result = await usecase('123');

      expect(result, const Left(CacheFailure('Cache Error')));
    });
  });
}
