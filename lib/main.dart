import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:splash_screen/core/constants/globals.dart';
import 'package:splash_screen/core/themes/light_theme.dart';
import 'package:splash_screen/screens/splash_screen.dart';
import 'package:splash_screen/services/firebase_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await FirebaseService.instance.init();
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
          scaffoldMessengerKey: snackbarKey,
          navigatorKey:navigationkey ,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          // initialRoute: '/',
          // routes: {
          //   '/': (context) => const SplashVideoScreen(),
          //   '/home': (context) => const HomePage(),
          // },
          home: SplashScreen(),
        );
      },
    );
  }
}
