import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/app_initializer.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/cubit/user_cubit.dart';
import 'package:tal3a/features/splash_screen/splash_screen.dart';

void main() async {
  await AppInitializer.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()..loadUserFromLocal()),
      ],
      child: MyApp(),
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
        return MaterialApp(
          title: "tal3a",
          scaffoldMessengerKey: snackbarKey,
          navigatorKey: navigationkey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          // initialRoute: '/',
          // routes: {
          //   '/': (context) => const SplashVideoScreen(),
          //   '/home': (context) => const HomePage(),
          // },
          home: const SplashScreen(),
        );
      },
    );
  }
}
