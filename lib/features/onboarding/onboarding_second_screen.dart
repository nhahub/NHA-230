import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/app_assets.dart';
import 'onboarding_third _screen.dart';

class OnboardingSecondScreen extends StatelessWidget {
  const OnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(stanley),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Positioned(
              bottom: 400.h,
              left:8.h,
              child: Text(onboardingFirstLine,
                  style: Theme.of(context).textTheme.titleLarge
              ),
            ),Positioned(
              bottom: 320.h,
              left:200.h,
              child: Text(onboardingSecondLine,
                  style: Theme.of(context).textTheme.titleLarge
              ),
            ),
            Positioned(
                bottom: 90.h,
                left:320.h,
                child: IconButton(
                  icon: SvgPicture.asset(firstIconOnboarding), onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => OnboardingThirdScreen(),
                      transitionDuration: Duration(milliseconds: 300),
                      reverseTransitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },))
          ]
      ),
    );
  }
}
