import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> initDependencies() async {
  // 1. External (Dio, Hive, etc.)
  sl.registerLazySingleton(() => buildDioClient());

  // 2. Core (NetworkInfo, etc.)

  // 3. Data Sources

  // 4. Repositories

  // 5. Use Cases

  // 6. Blocs/Cubits
}
