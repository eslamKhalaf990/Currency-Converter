import 'package:flutter/material.dart';

import 'core/di/injection.dart' as di;

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
        ), // EFG blue-ish seed
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Currency Converter Initialized')),
      ),
    );
  }
}
