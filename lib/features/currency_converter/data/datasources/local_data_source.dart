import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../../core/utils/json_parser.dart';
import '../models/conversion_record_model.dart';
import '../models/exchange_rate_model.dart';

/// Contract dictating operations acting strictly upon local device storage.
abstract class CurrencyLocalDataSource {
  /// Commits a successful conversion safely into the permanent local disk history log.
  Future<void> saveConversion(ConversionRecordModel record);

  /// Rehydrates the chronological local disk history log back into structural Dart Lists.
  Future<List<ConversionRecordModel>> getHistory();

  /// Deletes a specific existing user conversion cleanly out of the active local disk history log.
  Future<void> deleteHistoryEntry(String id);

  /// Synchronously dumps the active network values straight into the fallback cache list.
  Future<void> cacheExchangeRates(
    String baseCurrency,
    List<ExchangeRateModel> rates,
  );

  /// Pulls the latest successful cached connection string arrays up into populated Dart lists.
  Future<List<ExchangeRateModel>> getCachedExchangeRates(String baseCurrency);
}

/// Standardized concrete implementation managing multiple Hive localized boxes concurrently.
class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final Box<String> historyBox;
  final Box<String> ratesCacheBox;

  CurrencyLocalDataSourceImpl({
    required this.historyBox,
    required this.ratesCacheBox,
  });

  @override
  Future<void> saveConversion(ConversionRecordModel record) async {
    final jsonStr = jsonEncode(record.toJson());
    await historyBox.put(record.id, jsonStr);
  }

  @override
  Future<List<ConversionRecordModel>> getHistory() async {
    final values = historyBox.values.toList();
    return await compute(parseHistoryRecords, values);
  }

  @override
  Future<void> deleteHistoryEntry(String id) async {
    await historyBox.delete(id);
  }

  @override
  Future<void> cacheExchangeRates(
    String baseCurrency,
    List<ExchangeRateModel> rates,
  ) async {
    final list = rates.map((r) => r.toJson()).toList();
    final jsonStr = jsonEncode(list);
    await ratesCacheBox.put(baseCurrency, jsonStr);
  }

  @override
  Future<List<ExchangeRateModel>> getCachedExchangeRates(
    String baseCurrency,
  ) async {
    final jsonStr = ratesCacheBox.get(baseCurrency);
    if (jsonStr == null) {
      throw HiveError('No cached rates found for $baseCurrency');
    }

    return await compute(parseExchangeRatesList, jsonStr);
  }
}
