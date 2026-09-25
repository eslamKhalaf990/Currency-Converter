import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/features/history/data/models/conversion_record_model.dart';
import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';

void main() {
  final tModel = ConversionRecordModel(
    id: '123',
    baseCurrency: 'USD',
    targetCurrency: 'EUR',
    baseAmountCents: 1000,
    convertedAmountCents: 850,
    date: DateTime.parse('2023-01-01T12:00:00.000Z'),
  );

  test('should be a subclass of ConversionRecord entity', () async {
    expect(tModel, isA<ConversionRecord>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON has all required fields', () {
      final Map<String, dynamic> jsonMap = {
        'id': '123',
        'baseCurrency': 'USD',
        'targetCurrency': 'EUR',
        'baseAmountCents': 1000,
        'convertedAmountCents': 850,
        'date': '2023-01-01T12:00:00.000Z',
      };

      final result = ConversionRecordModel.fromJson(jsonMap);

      expect(result, tModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tModel.toJson();
      final expectedMap = {
        'id': '123',
        'baseCurrency': 'USD',
        'targetCurrency': 'EUR',
        'baseAmountCents': 1000,
        'convertedAmountCents': 850,
        'date': '2023-01-01T12:00:00.000Z',
      };

      expect(result, expectedMap);
    });
  });
}
