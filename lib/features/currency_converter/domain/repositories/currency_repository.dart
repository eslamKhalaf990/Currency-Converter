import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversion_record.dart';
import '../entities/exchange_rate.dart';

/// Contract dictating how the application will fetch live rates and manage conversion history.
/// All implementations must catch their own raw exceptions and route them into the Either functional wrapper.
abstract class CurrencyRepository {
  /// Fetches a list of live available exchange rates based on the provided base currency.
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates(
    String baseCurrency,
  );

  /// Dynamically pulls the full dictionary of supported currencies from the API.
  Future<Either<Failure, Map<String, String>>> getCurrencies();

  /// Persists a newly calculated conversion record into local device storage.
  Future<Either<Failure, void>> saveConversion(ConversionRecord record);

  /// Retrieves the chronological history of all saved conversions from local storage.
  Future<Either<Failure, List<ConversionRecord>>> getHistory();

  /// Removes a single specific conversion event from the local storage history by its ID.
  Future<Either<Failure, void>> deleteHistoryEntry(String id);
}
