import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tal3a/cubit/localization/locale_cubit.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/data/datasources/local/user_local_data.dart';
import 'package:tal3a/cubit/theme/theme_cubit.dart';
import 'package:tal3a/data/datasources/local/user_settings.dart';

class AppInitializer {
  static late ThemeCubit themeCubit;
  static late LocaleCubit localeCubit;
  static late UserCubit userCubit;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await Hive.initFlutter();
    await UserSettings.init();
    await UserLocalData().init();

    // أنشئ الـ cubit مرة واحدة
    userCubit = UserCubit();

    // حمّل بيانات المستخدم والفافوريتس على نفس الـ cubit
    await userCubit.loadUserFromLocal();
    await userCubit.loadFavorites();

    themeCubit = ThemeCubit(initialIsDark: ThemeSettings().isDark());

    localeCubit = LocaleCubit(
      initialLocale: LocalizationsSettings().getLocale(),
    );
  }
}
