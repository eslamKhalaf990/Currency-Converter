import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

/// Represents a single currency exchange rate for a given base.
/// Holds the target currency code and the multiplier rate needed for conversion calculations.
class ExchangeRate extends Equatable {
  /// The currency code being converted from (e.g., 'USD').
  final String baseCurrency;

  /// The currency code being converted to (e.g., 'AED').
  final String targetCurrency;

  /// The multiplier applied to the base amount.
  /// Uses Decimal instead of double to prevent floating point precision errors.
  final Decimal rate;

  const ExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
  });

  @override
  List<Object?> get props => [baseCurrency, targetCurrency, rate];
}
