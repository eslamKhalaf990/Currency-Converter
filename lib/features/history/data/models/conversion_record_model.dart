import 'package:currency_converter/features/history/domain/entities/conversion_record.dart';

/// Data transport representation of a history record saved to the Hive local device box.
/// Inherits strict use of minor integer amounts from the core Domain.
class ConversionRecordModel extends ConversionRecord {
  const ConversionRecordModel({
    required super.id,
    required super.baseCurrency,
    required super.targetCurrency,
    required super.baseAmountCents,
    required super.convertedAmountCents,
    required super.date,
  });

  /// Translates unstructured `Map<String, dynamic>` output from local Hive into structured memory models.
  factory ConversionRecordModel.fromJson(Map<String, dynamic> json) {
    return ConversionRecordModel(
      id: json['id'] as String,
      baseCurrency: json['baseCurrency'] as String,
      targetCurrency: json['targetCurrency'] as String,
      baseAmountCents: json['baseAmountCents'] as int,
      convertedAmountCents: json['convertedAmountCents'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// Exports local models back down to standard Maps representing records for saving in Hive.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'baseAmountCents': baseAmountCents,
      'convertedAmountCents': convertedAmountCents,
      'date': date.toIso8601String(),
    };
  }
}
