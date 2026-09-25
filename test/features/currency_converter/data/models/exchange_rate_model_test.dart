import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/features/currency_converter/data/models/exchange_rate_model.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/exchange_rate.dart';

void main() {
  final tExchangeRateModel = ExchangeRateModel(
    baseCurrency: 'USD',
    targetCurrency: 'EUR',
    rate: Decimal.parse('0.85'),
  );

  test('should be a subclass of ExchangeRate entity', () async {
    expect(tExchangeRateModel, isA<ExchangeRate>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON has all required fields', () {
      final Map<String, dynamic> jsonMap = {
        'base': 'USD',
        'quote': 'EUR',
        'rate': 0.85,
      };

      final result = ExchangeRateModel.fromJson(jsonMap);

      expect(result, tExchangeRateModel);
    });

    test('should parse correctly even if rate is a string in JSON', () {
      final Map<String, dynamic> jsonMap = {
        'base': 'USD',
        'quote': 'EUR',
        'rate': '0.85',
      };

      final result = ExchangeRateModel.fromJson(jsonMap);

      expect(result, tExchangeRateModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tExchangeRateModel.toJson();
      final expectedMap = {'base': 'USD', 'quote': 'EUR', 'rate': '0.85'};

      expect(result, expectedMap);
    });
  });
}
