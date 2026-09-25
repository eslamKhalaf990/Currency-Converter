import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/currency_converter/data/datasources/local_data_source.dart';
import '../../features/currency_converter/data/datasources/remote_data_source.dart';
import '../../features/currency_converter/data/repositories/currency_repository_impl.dart';
import '../../features/currency_converter/domain/repositories/currency_repository.dart';
import '../../features/currency_converter/domain/usecases/delete_history_entry.dart';
import '../../features/currency_converter/domain/usecases/get_currencies.dart';
import '../../features/currency_converter/domain/usecases/get_exchange_rates.dart';
import '../../features/currency_converter/domain/usecases/get_history.dart';
import '../../features/currency_converter/domain/usecases/save_conversion.dart';
import '../../features/currency_converter/presentation/bloc/converter_bloc.dart';
import '../../features/currency_converter/presentation/bloc/history/history_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> initDependencies() async {
  // 1. External (Dio, Hive, etc.)
  sl.registerLazySingleton(() => buildDioClient());

  await Hive.initFlutter();
  final historyBox = await Hive.openBox<String>('historyBox');
  final ratesCacheBox = await Hive.openBox<String>('ratesCacheBox');

  // 2. Core (NetworkInfo, etc.)

  // 3. Data Sources
  sl.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(
      historyBox: historyBox,
      ratesCacheBox: ratesCacheBox,
    ),
  );

  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(dio: sl()),
  );

  // 4. Repositories
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // 5. Use Cases
  sl.registerLazySingleton(() => GetExchangeRates(sl()));
  sl.registerLazySingleton(() => GetCurrencies(sl()));
  sl.registerLazySingleton(() => SaveConversion(sl()));
  sl.registerLazySingleton(() => GetHistory(sl()));
  sl.registerLazySingleton(() => DeleteHistoryEntry(sl()));

  // 6. Blocs/Cubits
  sl.registerFactory(
    () => HistoryBloc(getHistory: sl(), deleteHistoryEntry: sl()),
  );

  sl.registerFactory(
    () => ConverterBloc(getExchangeRates: sl(), saveConversion: sl()),
  );
}
