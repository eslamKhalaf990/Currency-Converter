import 'package:dartz/dartz.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';

abstract class HistoryRepository {
  Future<Either<Failure, void>> saveConversion(ConversionRecord record);
  Future<Either<Failure, List<ConversionRecord>>> getHistory();
  Future<Either<Failure, void>> deleteHistoryEntry(String id);
}
