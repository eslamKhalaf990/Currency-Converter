import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/di/injection.dart' as di;
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/converter/presentation/pages/converter_page.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_bloc.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_event.dart';
import 'package:currency_converter/features/history/presentation/pages/history_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ConverterPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConverterBloc>(
          create: (_) => di.sl<ConverterBloc>(),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => di.sl<HistoryBloc>()..add(const LoadHistory()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Currency Converter'),
              centerTitle: true,
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                if (index == 1) {
                  // Refresh history when navigating to the history tab
                  context.read<HistoryBloc>().add(const LoadHistory());
                }
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.currency_exchange_outlined),
                  selectedIcon: Icon(Icons.currency_exchange),
                  label: 'Converter',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: 'History',
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
