import 'package:equatable/equatable.dart';

/// Represents a completed currency conversion event in the app's history.
/// Monetary amounts are stored strictly as integer minor units (cents) to avoid precision loss.
class ConversionRecord extends Equatable {
  /// Unique identifier for the record (typically a UUID).
  final String id;

  /// The currency code converted from (e.g., 'USD').
  final String baseCurrency;

  /// The currency code converted to (e.g., 'AED').
  final String targetCurrency;

  /// The inputted mathematical amount represented in minor units (e.g. $10.50 -> 1050).
  final int baseAmountCents;

  /// The resulting calculated amount represented in minor units.
  final int convertedAmountCents;

  /// The exact timestamp the conversion was processed.
  final DateTime date;

  const ConversionRecord({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.baseAmountCents,
    required this.convertedAmountCents,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    baseCurrency,
    targetCurrency,
    baseAmountCents,
    convertedAmountCents,
    date,
  ];
}
