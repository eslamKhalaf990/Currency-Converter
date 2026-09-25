import 'package:decimal/decimal.dart';

import '../../domain/entities/exchange_rate.dart';

/// Data transport representation of an exchange rate fetching from the external network.
/// Automatically maps remote JSON variables directly to domain entity fields.
class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.baseCurrency,
    required super.targetCurrency,
    required super.rate,
  });

  /// Decodes raw remote JSON into the structural model.
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCurrency: json['base'] as String,
      targetCurrency: json['quote'] as String,
      rate: Decimal.parse(json['rate'].toString()),
    );
  }

  /// Encodes the model back into clean JSON format for potential data-layer cache persisting.
  Map<String, dynamic> toJson() {
    return {
      'base': baseCurrency,
      'quote': targetCurrency,
      'rate': rate.toString(),
    };
  }
}
