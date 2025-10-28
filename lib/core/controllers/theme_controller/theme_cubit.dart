import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _boxName = 'settings';
  static const String _keyIsDark = 'isDark';

  ThemeCubit({required bool initialIsDark}) : super(ThemeState(isDark: initialIsDark));

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDark;
    await _saveToBox(newIsDark);
    emit(state.copyWith(isDark: newIsDark));
  }
  Future<void> setDark() async {
    if (!state.isDark) {
      await _saveToBox(true);
      emit(state.copyWith(isDark: true));
    }
  }

  Future<void> setLight() async {
    if (state.isDark) {
      await _saveToBox(false);
      emit(state.copyWith(isDark: false));
    }
  }
  Future<void> loadFromBox() async {
    final box = await Hive.openBox(_boxName);
    final val = box.get(_keyIsDark, defaultValue: false) as bool;
    emit(state.copyWith(isDark: val));
  }

  Future<void> _saveToBox(bool value) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_keyIsDark, value);
  }
}
