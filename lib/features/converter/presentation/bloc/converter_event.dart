import 'package:equatable/equatable.dart';

sealed class ConverterEvent extends Equatable {
  const ConverterEvent();

  @override
  List<Object?> get props => [];
}

final class ConvertCurrenciesRequested extends ConverterEvent {
  final String fromCurrency;
  final String toCurrency;
  final String amount;

  const ConvertCurrenciesRequested({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}
