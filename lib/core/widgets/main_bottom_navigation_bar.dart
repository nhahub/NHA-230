import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:tal3a/features/home/providers/bottom_navigation_bar_provider.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BottomNavigationBarProvider, int>(
      selector: (_, provider) => provider.currentIndex,
      builder: (context, currentIndex, child) {
        return SizedBox(height: AppSizes.height200,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<BottomNavigationBarProvider>().changeIndex(index);
            },
            iconSize:AppSizes.radius80 ,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.location_pin),
                label: 'Map',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
