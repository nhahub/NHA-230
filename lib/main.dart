import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/app_initializer.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/core/themes/dark_theme.dart';
import 'package:tal3a/cubit/theme/theme_state.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/features/splash_screen/splash_screen.dart';
import 'package:tal3a/cubit/theme/theme_cubit.dart';
import 'package:tal3a/firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppInitializer.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()..loadUserFromLocal()),
        BlocProvider<ThemeCubit>.value(value: AppInitializer.themeCubit),
      ],
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
      builder: (_, __) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: "Tal3a",
              scaffoldMessengerKey: snackBarKey,
              navigatorKey: navigationKey,
              debugShowCheckedModeBanner: false,
              theme: LightTheme.lightTheme(context),
              darkTheme: DarkTheme.darkTheme(context),
              themeMode: state.themeMode,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
