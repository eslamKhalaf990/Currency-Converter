import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:currency_converter/core/utils/json_parser.dart';
import 'package:currency_converter/features/converter/data/models/exchange_rate_model.dart';

abstract class ConverterLocalDataSource {
  Future<void> cacheExchangeRates(String baseCurrency, List<ExchangeRateModel> rates);
  Future<List<ExchangeRateModel>> getCachedExchangeRates(String baseCurrency);
}

class ConverterLocalDataSourceImpl implements ConverterLocalDataSource {
  final Box<String> ratesCacheBox;

  ConverterLocalDataSourceImpl({required this.ratesCacheBox});

  @override
  Future<void> cacheExchangeRates(String baseCurrency, List<ExchangeRateModel> rates) async {
    final list = rates.map((r) => r.toJson()).toList();
    final jsonStr = jsonEncode(list);
    await ratesCacheBox.put(baseCurrency, jsonStr);
  }

  @override
  Future<List<ExchangeRateModel>> getCachedExchangeRates(String baseCurrency) async {
    final jsonStr = ratesCacheBox.get(baseCurrency);
    if (jsonStr == null) {
      throw HiveError('No cached rates found for $baseCurrency');
    }
    return await compute(parseExchangeRatesList, jsonStr);
  }
}
