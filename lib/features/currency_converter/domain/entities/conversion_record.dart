import 'package:equatable/equatable.dart';

class ConversionRecord extends Equatable {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final int baseAmountCents;
  final int convertedAmountCents;
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
