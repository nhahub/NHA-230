import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/home/screens/home_page.dart';
import 'package:tal3a/services/firebase_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.init();
  await Hive.initFlutter();


  const String boxName = 'settings';
  const String keyIsDark = 'isDark';


  final box = await Hive.openBox(boxName);
  final bool isDark = box.get(keyIsDark, defaultValue: false) as bool;
  final themeCubit = ThemeCubit(initialIsDark: isDark);

  await themeCubit.loadFromBox();

  runApp(
    BlocProvider<ThemeCubit>.value(
      value: themeCubit,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              scaffoldMessengerKey: snackBarKey,
              navigatorKey: navigationKey,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(context),
              darkTheme: AppTheme.darkTheme(context),
              themeMode: state.themeMode,
              // routes: AppRoutes.routes,
              home: HomePage(),
            );
          },
        );
      },
    );
  }
}
