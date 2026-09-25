import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/di/injection.dart' as di;
import 'package:currency_converter/core/theme/app_theme.dart';
import 'package:currency_converter/core/theme/theme_cubit.dart';
import 'package:currency_converter/features/bottom_nav_bar/presentation/pages/bottom_nav_bar_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const EfgCurrencyConverterApp());
}

class EfgCurrencyConverterApp extends StatelessWidget {
  const EfgCurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Currency Converter',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const BottomNavBarPage(),
          );
        },
      ),
    );
  }
}
