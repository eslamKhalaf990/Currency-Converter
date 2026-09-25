import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/di/injection.dart' as di;
import 'package:currency_converter/core/theme/app_theme.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/converter/presentation/pages/converter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const EfgCurrencyConverterApp());
}

class EfgCurrencyConverterApp extends StatelessWidget {
  const EfgCurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => di.sl<ConverterBloc>(),
        child: const ConverterPage(),
      ),
    );
  }
}
