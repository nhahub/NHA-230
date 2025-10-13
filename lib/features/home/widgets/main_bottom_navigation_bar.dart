import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/features/home/providers/bottom_navigation_bar_provider.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BottomNavigationBarProvider, int>(
      selector: (_, provider) => provider.currentIndex,
      builder: (context, currentIndex, child) {
        return SizedBox(height: 200.h,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<BottomNavigationBarProvider>().changeIndex(index);
            },
            iconSize:80.sp,
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
