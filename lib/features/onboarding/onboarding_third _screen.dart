import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/authentication/presentation/screens/login_screen.dart';


class OnboardingThirdScreen extends StatelessWidget {
  const OnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppAssets.taxi),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Positioned(
              bottom: 400.h,
              left: 8.h,
              child: Text(
                AppStrings.onboardingFirstLine,
                style: theme.textTheme.titleLarge,
              ),
            ),Positioned(
              bottom: 320.h,
              left: 200.h,
              child: Text(
                AppStrings.onboardingSecondLine,
                style: theme.textTheme.titleLarge,
              ),
            ),
            Positioned(
                bottom: 90.h,
                left:320.h,
                child: IconButton(
                  icon: SvgPicture.asset(AppAssets.secondIconOnboarding), onPressed: () {
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
