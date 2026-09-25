import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'theme_mode';
  final Box _settingsBox;

  ThemeCubit(this._settingsBox) : super(_loadThemeMode(_settingsBox));

  static ThemeMode _loadThemeMode(Box box) {
    final themeIndex = box.get(_themeKey, defaultValue: ThemeMode.system.index);
    return ThemeMode.values[themeIndex as int];
  }

  void updateTheme(ThemeMode themeMode) {
    _settingsBox.put(_themeKey, themeMode.index);
    emit(themeMode);
  }
}
