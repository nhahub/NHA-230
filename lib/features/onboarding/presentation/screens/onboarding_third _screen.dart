import 'package:flutter/material.dart';
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
              bottom: AppSizes.height400,
              left: 0,
              right: 0,
              child: Text(
                AppStrings.onboardingThirdScreenFirstLine,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),Positioned(
              bottom: AppSizes.height320,
              left: 0,
              right: 0,
              child: Text(
                AppStrings.onboardingThirdScreenSecondLine,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),
            Positioned(
                bottom: AppSizes.height90,
                left: AppSizes.width400,
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
