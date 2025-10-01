import 'package:final_project/features/home/Providers/bottom_navigation_bar_provider.dart';
import 'package:final_project/features/home/Screens/home_screen.dart';
import 'package:final_project/features/map/map_screen.dart';
import 'package:final_project/features/profile/profile_screen.dart';
import 'package:final_project/features/home/Widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
