import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/features/navigation/root_page.dart';
import 'package:tal3a/features/onboarding/presentation/screens/onboarding_first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for animation, then check user state
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateBasedOnUser();
      }
    });
  }

  void _navigateBasedOnUser() {
    final user = context.read<UserCubit>().state;
    
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RootPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingFirstScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/animations/splash_screen_2.json'),
      ),
    );
  }
}