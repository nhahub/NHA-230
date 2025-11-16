import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'onboarding_third _screen.dart';
import 'package:tal3a/core/core.dart';

class OnboardingSecondScreen extends StatelessWidget {
  const OnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.stanley),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: AppSizes.height400,
            left: 0,
            right: 0,
            child: Text(
              AppStrings.onboardingSecondScreenFirstLine,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Positioned(
            bottom: AppSizes.height320,
            left: 0,
            right: 0,
            child: Text(
              AppStrings.onboardingSecondScreenSecondLine,textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Positioned(
            bottom: AppSizes.height90,
            left: AppSizes.width400,
            child: IconButton(
              icon: SvgPicture.asset(AppAssets.firstIconOnboarding),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        OnboardingThirdScreen(),
                    transitionDuration: Duration(milliseconds: 300),
                    reverseTransitionDuration: Duration(milliseconds: 300),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
