import 'dart:convert';

import '../../features/currency_converter/data/models/exchange_rate_model.dart';
import '../../features/currency_converter/data/models/conversion_record_model.dart';

/// Top-level helper function to convert string payloads mapping out of the UI thread context.
Map<String, dynamic> parseJsonObject(String responseBody) {
  return jsonDecode(responseBody) as Map<String, dynamic>;
}

/// Generic JSON list parser utilizing isolated compute logic.
List<dynamic> parseJsonList(String responseBody) {
  return jsonDecode(responseBody) as List<dynamic>;
}

/// Specifically parses heavily populated raw exchange rate strings into native Models while executing inside Dart's `compute()` isolation limit.
List<ExchangeRateModel> parseExchangeRatesList(String responseBody) {
  final decoded = jsonDecode(responseBody) as List<dynamic>;
  return decoded
      .map((json) => ExchangeRateModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Parses an iterable of JSON strings representing conversion records into a sorted List of models.
List<ConversionRecordModel> parseHistoryRecords(List<String> values) {
  final List<ConversionRecordModel> history = [];
  for (final value in values) {
    final map = jsonDecode(value) as Map<String, dynamic>;
    history.add(ConversionRecordModel.fromJson(map));
  }
  history.sort((a, b) => b.date.compareTo(a.date));
  return history;
}
