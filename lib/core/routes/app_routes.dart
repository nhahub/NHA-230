import 'package:flutter/material.dart';
import 'package:tal3a/features/splash_screen/splash_screen.dart';
import 'package:tal3a/features/authentication/presentation/screens/login_screen.dart';
import 'package:tal3a/features/authentication/presentation/screens/signup_screen.dart';
import 'package:tal3a/features/home/screens/home_screen.dart';
import 'package:tal3a/features/home/screens/search_screen.dart';
import 'package:tal3a/features/map/presentation/screens/map_screen.dart';
import 'package:tal3a/features/profile/presentation/screens/profile_screen.dart';
import 'package:tal3a/features/onboarding/presentation/screens/onboarding_first_screen.dart';
import 'package:tal3a/features/onboarding/presentation/screens/onboarding_second_screen.dart';
import 'package:tal3a/features/onboarding/presentation/screens/onboarding_third _screen.dart';
import 'package:tal3a/features/navigation/root_page.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String onboardingFirst = '/onboarding-first';
  static const String onboardingSecond = '/onboarding-second';
  static const String onboardingThird = '/onboarding-third';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String root = '/home';
  static const String homeScreen = '/home-screen';
  static const String search = '/search';
  static const String map = '/map';
  static const String profile = '/profile';

  // Routes Map
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboardingFirst: (context) => const OnboardingFirstScreen(),
    onboardingSecond: (context) => const OnboardingSecondScreen(),
    onboardingThird: (context) => const OnboardingThirdScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => SignupScreen(),
    root: (context) => const RootPage(),
    homeScreen: (context) => HomeScreen(),
    search: (context) => const SearchScreen(),
    map: (context) => const MapScreen(),
    profile: (context) => const ProfileScreen(),
  };
}