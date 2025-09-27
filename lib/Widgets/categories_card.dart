import 'package:final_project/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/category_provider.dart';
import '../Utils/responsive.dart';

class CategoriesCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final int index;

  const CategoriesCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final bool isSelected = categoryProvider.selectedIndex == index;

        return GestureDetector(
          onTap: () {
            categoryProvider.select(index);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Responsive(context).height(10),
            ),
            child: Card(
              color: isSelected ? white : offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                  color: isSelected ? primaryBlue : offWhite,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Responsive(context).height(10),
                  horizontal: Responsive(context).width(35),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(iconPath, width: Responsive(context).width(50)),
                    SizedBox(width: Responsive(context).width(15)),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? primaryBlue : placeholderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
