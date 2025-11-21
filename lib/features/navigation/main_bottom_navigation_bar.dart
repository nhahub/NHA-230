import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:tal3a/features/home/providers/bottom_navigation_bar_provider.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<BottomNavigationBarProvider, int>(
      selector: (_, provider) => provider.currentIndex,
      builder: (context, currentIndex, child) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: AppSizes.height40,
              right: AppSizes.width20,
              left: AppSizes.width20,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.height20,
                horizontal: AppSizes.width32,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppSizes.radius100),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 5,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _navItem(
                      context,
                      index: 0,
                      icon: Icons.location_pin,
                      label: "",
                      selected: currentIndex == 0,
                    ),
                  ),
                  Expanded(
                    child: _navItem(
                      context,
                      index: 1,
                      icon: Icons.home,
                      label:"",
                      selected: currentIndex == 1,
                    ),
                  ),
                  Expanded(
                    child: _navItem(
                      context,
                      index: 2,
                      icon: Icons.favorite,
                      label: "",
                      selected: currentIndex == 2,
                    ),
                  ),
                  Expanded(
                    child: _navItem(
                      context,
                      index: 3,
                      icon: Icons.person,
                      label: "",
                      selected: currentIndex == 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(
      BuildContext context, {
        required int index,
        required IconData icon,
        required String label,
        required bool selected,
      }) {
    final provider = context.read<BottomNavigationBarProvider>();

    return GestureDetector(
      onTap: () => provider.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: selected ? 1.1 : 1,
            duration: const Duration(milliseconds: 250),
            child: Icon(
              icon,
              size: AppSizes.radius100,
              color: selected ? Colors.blue : Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: selected ? Colors.blue : Colors.grey,
              fontSize: AppSizes.width38,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
