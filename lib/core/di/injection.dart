import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:currency_converter/features/converter/data/datasources/converter_local_data_source.dart';
import 'package:currency_converter/features/converter/data/datasources/converter_remote_data_source.dart';
import 'package:currency_converter/features/converter/data/repositories/converter_repository_impl.dart';
import 'package:currency_converter/features/converter/domain/repositories/converter_repository.dart';
import 'package:currency_converter/features/converter/domain/usecases/get_currencies.dart';
import 'package:currency_converter/features/converter/domain/usecases/get_exchange_rates.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';

import 'package:currency_converter/features/history/data/datasources/history_local_data_source.dart';
import 'package:currency_converter/features/history/data/repositories/history_repository_impl.dart';
import 'package:currency_converter/features/history/domain/repositories/history_repository.dart';
import 'package:currency_converter/features/history/domain/usecases/delete_history_entry.dart';
import 'package:currency_converter/features/history/domain/usecases/get_history.dart';
import 'package:currency_converter/features/history/domain/usecases/save_conversion.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_bloc.dart';

import 'package:currency_converter/core/network/dio_client.dart';
import 'package:currency_converter/core/theme/theme_cubit.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> initDependencies() async {
  // 1. External (Dio, Hive, etc.)
  sl.registerLazySingleton(() => buildDioClient());

  await Hive.initFlutter();
  final historyBox = await Hive.openBox<String>('historyBox');
  final ratesCacheBox = await Hive.openBox<String>('ratesCacheBox');
  final settingsBox = await Hive.openBox('settingsBox');

  // 2. Data Sources - Converter
  sl.registerLazySingleton<ConverterLocalDataSource>(
    () => ConverterLocalDataSourceImpl(ratesCacheBox: ratesCacheBox),
  );
  sl.registerLazySingleton<ConverterRemoteDataSource>(
    () => ConverterRemoteDataSourceImpl(dio: sl()),
  );

  // 3. Data Sources - History
  sl.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(historyBox: historyBox),
  );

  // 4. Repositories
  sl.registerLazySingleton<ConverterRepository>(
    () => ConverterRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(localDataSource: sl()),
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
  
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(settingsBox));
}
