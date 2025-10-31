import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/data/datasources/local/user_settings.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required bool initialIsDark})
    : super(ThemeState(isDark: initialIsDark));

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDark;
    ThemeSettings().toggleTheme(newIsDark);
    emit(state.copyWith(isDark: newIsDark));
  }

  Future<void> loadFromBox() async {
    final val = ThemeSettings().isDark();
    emit(state.copyWith(isDark: val));
  }
}
