import 'dart:convert';

import 'package:decimal/decimal.dart';

import 'package:currency_converter/features/converter/data/models/exchange_rate_model.dart';
import 'package:currency_converter/features/history/data/models/conversion_record_model.dart';

/// Top-level helper function to convert string payloads mapping out of the UI thread context.
Map<String, dynamic> parseJsonObject(String responseBody) {
  return jsonDecode(responseBody) as Map<String, dynamic>;
}

/// Generic JSON list parser utilizing isolated compute logic.
List<dynamic> parseJsonList(String responseBody) {
  return jsonDecode(responseBody) as List<dynamic>;
}

/// Specifically parses heavily populated raw exchange rate strings into native Models while executing inside Dart's `compute()` isolation limit.
/// Used for reading from the Hive cache which stores it as a List of Maps.
List<ExchangeRateModel> parseExchangeRatesList(String responseBody) {
  final decoded = jsonDecode(responseBody) as List<dynamic>;
  return decoded
      .map((json) => ExchangeRateModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Helper function to parse already decoded map from Dio into models.
/// Dio automatically decodes JSON in a background isolate, so we don't need a string here.
List<ExchangeRateModel> mapFrankfurterResponse(Map<String, dynamic> decoded) {
  final baseCurrency = decoded['base'] as String;
  final ratesMap = decoded['rates'] as Map<String, dynamic>;

  return ratesMap.entries.map((entry) {
    return ExchangeRateModel(
      baseCurrency: baseCurrency,
      targetCurrency: entry.key,
      // Handle int or double seamlessly
      rate: Decimal.parse(entry.value.toString()),
    );
  }).toList();
}

/// Parses the unique Map payload returned directly from the Frankfurter API endpoint if it was a raw string.
List<ExchangeRateModel> parseFrankfurterResponse(String responseBody) {
  final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
  return mapFrankfurterResponse(decoded);
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
