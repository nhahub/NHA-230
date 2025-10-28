import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/core.dart';
import 'onboarding_second_screen.dart';

class OnboardingFirstScreen extends StatelessWidget {
  const OnboardingFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.tram),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: AppSizes.height400,
            left: AppSizes.width8,
            child: Text(
              AppStrings.onboardingFirstLine,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Positioned(
            bottom: AppSizes.height320,
            left: AppSizes.width200,
            child: Text(
              AppStrings.onboardingSecondLine,
              style: Theme.of(context).textTheme.titleLarge,
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
                        OnboardingSecondScreen(),
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
