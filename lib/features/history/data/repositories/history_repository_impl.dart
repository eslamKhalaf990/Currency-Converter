import 'package:dartz/dartz.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/repository/base_repository.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';
import 'package:currency_converter/features/history/data/datasources/history_local_data_source.dart';
import 'package:currency_converter/features/history/data/models/conversion_record_model.dart';

class HistoryRepositoryImpl extends BaseRepository implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl({required this.localDataSource});

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
