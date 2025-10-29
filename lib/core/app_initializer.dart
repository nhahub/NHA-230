import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tal3a/data/datasources/local/user_local_data.dart';
import 'package:tal3a/cubit/theme/theme_cubit.dart';

class AppInitializer {
  static const String _boxName = 'settings';
  static const String _keyIsDark = 'isDark';

  static late ThemeCubit themeCubit;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await Hive.initFlutter();
    await UserLocalData().init();

    final box = await Hive.openBox(_boxName);
    final bool isDark = box.get(_keyIsDark, defaultValue: false) as bool;
    themeCubit = ThemeCubit(initialIsDark: isDark);
    await themeCubit.loadFromBox();
  }
}
