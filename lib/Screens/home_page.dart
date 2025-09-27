import 'package:final_project/Screens/home_screen.dart';
import 'package:final_project/Screens/map_screen.dart';
import 'package:final_project/Screens/profile_screen.dart';
import 'package:final_project/Widgets/main_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/bottom_navigation_bar_provider.dart';

const List<Widget> _screens =[
  MapScreen(),
  HomeScreen(),
  ProfileScreen(),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BottomNavigationBarProvider>(
        builder: (context, navProvider, child) {
          return _screens[navProvider.currentIndex];
        },
      ),
      bottomNavigationBar: MainBottomNavBar()
    );
  }
}
