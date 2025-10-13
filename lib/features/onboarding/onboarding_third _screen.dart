import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:splash_screen/core/constants/app_assets.dart';
import 'package:splash_screen/features/authentication/login_screen.dart';
import 'package:splash_screen/features/home/screens/home_screen.dart';


class OnboardingThirdScreen extends StatelessWidget {
  const OnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(taxi),
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
                  icon: SvgPicture.asset(secondIconOnboarding), onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
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
