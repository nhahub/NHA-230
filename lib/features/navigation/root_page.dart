import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/features/favorites/presentation/screens/liked_screen.dart';
import 'package:tal3a/features/home/providers/bottom_navigation_bar_provider.dart';
import 'package:tal3a/features/home/screens/home_screen.dart';
import 'package:tal3a/features/navigation/main_bottom_navigation_bar.dart';
import 'package:tal3a/features/map/presentation/screens/map_screen.dart';
import 'package:tal3a/features/profile/presentation/screens/profile_screen.dart';

final List<Widget> _screens = [
  MapScreen(),
  HomeScreen(),
  LikedScreen(),
  ProfileScreen(),
];

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BottomNavigationBarProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Consumer<BottomNavigationBarProvider>(
              builder: (context, navProvider, child) {
                return IndexedStack(
                  index: navProvider.currentIndex,
                  children: _screens,
                );
              },
            ),

            const Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: MainBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
