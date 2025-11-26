import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  void setDarkTheme() {
    if (state.themeMode != ThemeMode.dark) {
      emit(state.copyWith(themeMode: ThemeMode.dark));
    }
  }

  void setTheme(bool isDark) {
    emit(state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  void setLightTheme() {
    if (state.themeMode != ThemeMode.light) {
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  void toggleTheme() {
    final newTheme = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    emit(state.copyWith(themeMode: newTheme));
  }

  void setSystemTheme() {
    if (state.themeMode != ThemeMode.system) {
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }
}
