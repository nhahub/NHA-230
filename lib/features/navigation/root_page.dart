import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/features/home/providers/bottom_navigation_bar_provider.dart';
import 'package:tal3a/features/home/screens/home_screen.dart';
import 'package:tal3a/features/navigation/main_bottom_navigation_bar.dart';
import 'package:tal3a/features/map/presentation/screens/map_screen.dart';
import 'package:tal3a/features/profile/presentation/screens/profile_screen.dart';


final List<Widget> _screens = [const MapScreen(), HomeScreen(), const ProfileScreen()];

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => BottomNavigationBarProvider(),
      child: Scaffold(
        body: Consumer<BottomNavigationBarProvider>(
          builder: (context, navProvider, child) {
            return _screens[navProvider.currentIndex];
          },
        ),
        bottomNavigationBar: MainBottomNavBar(),
      ),
    );
  }
}
