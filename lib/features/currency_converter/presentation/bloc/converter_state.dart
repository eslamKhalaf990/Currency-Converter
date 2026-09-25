import 'package:equatable/equatable.dart';

sealed class ConverterState extends Equatable {
  const ConverterState();

  @override
  List<Object?> get props => [];
}

final class ConverterInitial extends ConverterState {
  const ConverterInitial();
}

final class ConverterLoading extends ConverterState {
  const ConverterLoading();
}

final class ConverterSuccess extends ConverterState {
  final int resultMinorUnits;
  final String fromCurrency;
  final String toCurrency;
  final double rate;

  const ConverterSuccess({
    required this.resultMinorUnits,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
  });

  @override
  List<Object?> get props => [resultMinorUnits, fromCurrency, toCurrency, rate];
}

final class ConverterError extends ConverterState {
  final String message;

  const ConverterError(this.message);

  @override
  List<Object?> get props => [message];
}
