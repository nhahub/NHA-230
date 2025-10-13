import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/features/home/providers/bottom_navigation_bar_provider.dart';
import 'package:tal3a/features/home/screens/home_screen.dart';
import 'package:tal3a/features/home/widgets/main_bottom_navigation_bar.dart';
import 'package:tal3a/features/map/map_screen.dart';
import 'package:tal3a/features/profile/profile_screen.dart';


const List<Widget> _screens = [MapScreen(), HomeScreen(), ProfileScreen()];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
