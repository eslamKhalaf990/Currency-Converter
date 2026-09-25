import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

# 1. Use cases
write_file('test/features/currency_converter/domain/usecases/save_conversion_test.dart', """
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/save_conversion.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}
class FakeConversionRecord extends Fake implements ConversionRecord {}

void main() {
  late SaveConversion usecase;
  late MockCurrencyRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeConversionRecord());
  });

  setUp(() {
    mockRepository = MockCurrencyRepository();
    usecase = SaveConversion(mockRepository);
  });

  final tRecord = ConversionRecord(
    id: '123',
    baseCurrency: 'USD',
    targetCurrency: 'EUR',
    baseAmountCents: 1000,
    convertedAmountCents: 850,
    date: DateTime(2023),
  );

  group('SaveConversion', () {
    test('should save to the repository', () async {
      when(() => mockRepository.saveConversion(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tRecord);

      expect(result, const Right(null));
      verify(() => mockRepository.saveConversion(tRecord)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure on error', () async {
      when(() => mockRepository.saveConversion(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Cache Error')));

      final result = await usecase(tRecord);

      expect(result, const Left(CacheFailure('Cache Error')));
    });
  });
}
""")

write_file('test/features/currency_converter/domain/usecases/get_history_test.dart', """
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/conversion_record.dart';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/get_history.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late GetHistory usecase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
    usecase = GetHistory(mockRepository);
  });

  final tRecords = [
    ConversionRecord(
      id: '123',
      baseCurrency: 'USD',
      targetCurrency: 'EUR',
      baseAmountCents: 1000,
      convertedAmountCents: 850,
      date: DateTime(2023),
    )
  ];

  group('GetHistory', () {
    test('should get history from the repository', () async {
      when(() => mockRepository.getHistory())
          .thenAnswer((_) async => Right(tRecords));

      final result = await usecase(NoParams());

      expect(result, Right(tRecords));
      verify(() => mockRepository.getHistory()).called(1);
    });

    test('should return Failure on error', () async {
      when(() => mockRepository.getHistory())
          .thenAnswer((_) async => const Left(CacheFailure('Cache Error')));

      final result = await usecase(NoParams());

      expect(result, const Left(CacheFailure('Cache Error')));
    });
  });
}
""")

write_file('test/features/currency_converter/domain/usecases/delete_history_entry_test.dart', """
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/delete_history_entry.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  late DeleteHistoryEntry usecase;
  late MockCurrencyRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyRepository();
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
""")

# 2. Models
write_file('test/features/currency_converter/data/models/exchange_rate_model_test.dart', """
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
        'rate': 0.85
      };

      final result = ExchangeRateModel.fromJson(jsonMap);

      expect(result, tExchangeRateModel);
    });

    test('should parse correctly even if rate is a string in JSON', () {
      final Map<String, dynamic> jsonMap = {
        'base': 'USD',
        'quote': 'EUR',
        'rate': '0.85'
      };

      final result = ExchangeRateModel.fromJson(jsonMap);

      expect(result, tExchangeRateModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tExchangeRateModel.toJson();
      final expectedMap = {
        'base': 'USD',
        'quote': 'EUR',
        'rate': '0.85'
      };

      expect(result, expectedMap);
    });
  });
}
""")

write_file('test/features/currency_converter/data/models/conversion_record_model_test.dart', """
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/features/currency_converter/data/models/conversion_record_model.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/conversion_record.dart';

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
        'date': '2023-01-01T12:00:00.000Z'
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
        'date': '2023-01-01T12:00:00.000Z'
      };

      expect(result, expectedMap);
    });
  });
}
""")

# 3. JSON Parser
write_file('test/core/utils/json_parser_test.dart', """
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
        jsonEncode({"id": "1", "baseCurrency": "USD", "targetCurrency": "EUR", "baseAmountCents": 100, "convertedAmountCents": 85, "date": "2023-01-01T10:00:00Z"}),
        jsonEncode({"id": "2", "baseCurrency": "USD", "targetCurrency": "GBP", "baseAmountCents": 100, "convertedAmountCents": 75, "date": "2023-01-02T10:00:00Z"}),
      ];
      
      final result = parseHistoryRecords(jsonList);
      
      expect(result.length, 2);
      // It sorts by descending date! (b.date.compareTo(a.date))
      expect(result.first.id, '2'); // The later date
      expect(result.last.id, '1');
    });
  });
}
""")
