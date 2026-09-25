import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/di/injection.dart' as di;
import 'package:currency_converter/core/presentation/widgets/responsive_layout.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/converter/presentation/pages/converter_page.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_bloc.dart';
import 'package:currency_converter/features/history/presentation/bloc/history_event.dart';
import 'package:currency_converter/features/history/presentation/pages/history_page.dart';
import 'package:currency_converter/features/settings/presentation/pages/settings_page.dart';

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
    SettingsPage(),
  ];

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 1) {
      // Refresh history when navigating to the history tab
      context.read<HistoryBloc>().add(const LoadHistory());
    }
    setState(() {
      _currentIndex = index;
    });
  }

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
          final bodyContent = IndexedStack(
            index: _currentIndex,
            children: _pages,
          );

          return ResponsiveLayout(
            mobile: Scaffold(
              appBar: AppBar(
                title: const Text('Currency Converter'),
                centerTitle: true,
              ),
              body: bodyContent,
              bottomNavigationBar: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (idx) => _onDestinationSelected(context, idx),
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
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
            tablet: Scaffold(
              appBar: AppBar(
                title: const Text('Currency Converter'),
                centerTitle: true,
              ),
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (idx) => _onDestinationSelected(context, idx),
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.currency_exchange_outlined),
                        selectedIcon: Icon(Icons.currency_exchange),
                        label: Text('Converter'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history_outlined),
                        selectedIcon: Icon(Icons.history),
                        label: Text('History'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: bodyContent),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
