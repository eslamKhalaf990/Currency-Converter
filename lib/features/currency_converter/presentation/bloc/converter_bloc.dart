import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:decimal/decimal.dart';

import '../../domain/entities/conversion_record.dart';
import '../../domain/usecases/get_exchange_rates.dart';
import '../../domain/usecases/save_conversion.dart';
import 'converter_event.dart';
import 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final GetExchangeRates getExchangeRates;
  final SaveConversion saveConversion;

  ConverterBloc({required this.getExchangeRates, required this.saveConversion})
    : super(const ConverterInitial()) {
    on<ConvertCurrenciesRequested>(
      _onConvertCurrenciesRequested,
      transformer: droppable(), // Prevents duplicate rapid-tap submissions
    );
  }

  Future<void> _onConvertCurrenciesRequested(
    ConvertCurrenciesRequested event,
    Emitter<ConverterState> emit,
  ) async {
    emit(const ConverterLoading());

    // Basic validation logic
    final amountDec = Decimal.tryParse(event.amount);
    if (amountDec == null || amountDec <= Decimal.zero) {
      emit(const ConverterError('Please enter a valid positive amount.'));
      return;
    }
    if (event.fromCurrency == event.toCurrency) {
      emit(
        const ConverterError('Please select different currencies to convert.'),
      );
      return;
    }

    // Call domain usecase
    final ratesResult = await getExchangeRates(event.fromCurrency);

    await ratesResult.fold(
      (failure) async {
        emit(ConverterError(failure.message));
      },
      (ratesList) async {
        try {
          // Find target currency rate
          final targetRate = ratesList.firstWhere(
            (r) => r.targetCurrency == event.toCurrency,
            orElse: () => throw Exception('Target currency not supported.'),
          );

          // Calculate minor units strictly using Decimal logic
          final convertedDec = amountDec * targetRate.rate;
          final resultMinorUnits = (convertedDec * Decimal.fromInt(100))
              .toBigInt()
              .toInt();
          final baseAmountCents = (amountDec * Decimal.fromInt(100))
              .toBigInt()
              .toInt();

          emit(
            ConverterSuccess(
              resultMinorUnits: resultMinorUnits,
              fromCurrency: event.fromCurrency,
              toCurrency: event.toCurrency,
              rate: targetRate.rate.toDouble(),
            ),
          );

          // Save conversion record
          final record = ConversionRecord(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            baseCurrency: event.fromCurrency,
            targetCurrency: event.toCurrency,
            baseAmountCents: baseAmountCents,
            convertedAmountCents: resultMinorUnits,
            date: DateTime.now(),
          );

          await saveConversion(record);
        } catch (e) {
          emit(
            const ConverterError('Target currency exchange rate not found.'),
          );
        }
      },
    );
  }
}
