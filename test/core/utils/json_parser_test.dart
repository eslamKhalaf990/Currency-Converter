import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/core/utils/json_parser.dart';
import 'package:currency_converter/features/currency_converter/data/models/exchange_rate_model.dart';
import 'package:currency_converter/features/currency_converter/data/models/conversion_record_model.dart';

void main() {
  group('parseFrankfurterResponse', () {
    test('should parse correctly from Frankfurter nested object', () {
      final jsonStr = '''{
        "amount": 1.0,
        "base": "USD",
        "date": "2023-10-18",
        "rates": {
          "AUD": 1.5,
          "EUR": 0.85
        }
      }''';

      final result = parseFrankfurterResponse(jsonStr);

      expect(result.length, 2);
      expect(result.first.targetCurrency, 'AUD');
      expect(result.first.rate, Decimal.parse('1.5'));
      expect(result.last.targetCurrency, 'EUR');
      expect(result.last.rate, Decimal.parse('0.85'));
    });
  });

  group('parseExchangeRatesList', () {
    test('should parse correctly from cached Hive JSON list', () {
      final jsonStr = '''[
        {"base": "USD", "quote": "EUR", "rate": "0.85"},
        {"base": "USD", "quote": "AUD", "rate": "1.5"}
      ]''';

      final result = parseExchangeRatesList(jsonStr);

      expect(result.length, 2);
      expect(result.first, isA<ExchangeRateModel>());
      expect(result.first.targetCurrency, 'EUR');
    });
  });

  group('parseHistoryRecords', () {
    test('should parse list of strings into sorted list', () {
      final jsonList = [
        jsonEncode({
          "id": "1",
          "baseCurrency": "USD",
          "targetCurrency": "EUR",
          "baseAmountCents": 100,
          "convertedAmountCents": 85,
          "date": "2023-01-01T10:00:00Z",
        }),
        jsonEncode({
          "id": "2",
          "baseCurrency": "USD",
          "targetCurrency": "GBP",
          "baseAmountCents": 100,
          "convertedAmountCents": 75,
          "date": "2023-01-02T10:00:00Z",
        }),
      ];

      final result = parseHistoryRecords(jsonList);

      expect(result.length, 2);
      // It sorts by descending date! (b.date.compareTo(a.date))
      expect(result.first.id, '2'); // The later date
      expect(result.last.id, '1');
    });
  });
}
