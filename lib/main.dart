import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_first_screen.dart';

void main() {
  runApp(const MyApp());
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
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          // initialRoute: '/',
          // routes: {
          //   '/': (context) => const SplashVideoScreen(),
          //   '/home': (context) => const HomePage(),
          // },
          home: OnboardingFirstScreen(),
        );
      },
    );
  }
}
