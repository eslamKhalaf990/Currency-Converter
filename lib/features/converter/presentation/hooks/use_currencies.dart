import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:currency_converter/core/di/injection.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/converter/domain/usecases/get_currencies.dart';

List<Object> useCurrencies() {
  final supportedCurrencies = useState<List<String>>(['EUR', 'USD']);
  final isLoadingCurrencies = useState(true);

  useEffect(() {
    sl<GetCurrencies>()(const NoParams()).then((result) {
      result.fold(
        (failure) {
          isLoadingCurrencies.value = false;
        },
        (currenciesMap) {
          final keys = currenciesMap.keys.toList();
          if (!keys.contains('EUR')) keys.insert(0, 'EUR');
          if (!keys.contains('USD')) keys.insert(1, 'USD');

          supportedCurrencies.value = keys;
          isLoadingCurrencies.value = false;
        },
      );
    });
    return null;
  }, const []);

  return [supportedCurrencies.value, isLoadingCurrencies.value];
}
