import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/theme/theme_cubit.dart';
import 'package:currency_converter/core/theme/dimens.dart';
import 'package:currency_converter/core/presentation/widgets/responsive_page_container.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ResponsivePageContainer(
      child: ListView(
        padding: const EdgeInsets.all(Dimens.spacingL),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.spacingL),
            child: Text(
              'Settings',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, currentMode) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Theme Preference', style: theme.textTheme.titleMedium),
                  const SizedBox(height: Dimens.spacingM),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {currentMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      context.read<ThemeCubit>().updateTheme(newSelection.first);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
