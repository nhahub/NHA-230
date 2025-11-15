import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/home/providers/category_provider.dart';

class CategoriesCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? activeIconPath;
  final int index;
  final String collection;

  const CategoriesCard({
    super.key,
    required this.title,
    required this.collection,
    required this.iconPath,
    this.activeIconPath,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final bool isSelected = categoryProvider.selectedIndex == index;
        return GestureDetector(
          onTap: () {
            categoryProvider.select(index, collection);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.pd10v),
            child: Card(
              color: isSelected
                  ? theme.cardColor
                  : theme.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius100),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryBlue : theme.cardColor,
                  width: AppSizes.width4,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.pd10v,
                  horizontal: AppSizes.pd35h,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      isSelected && activeIconPath != null
                          ? activeIconPath!
                          : iconPath,
                      width: AppSizes.width50,
                    ),
                    SizedBox(width: AppSizes.width15),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.placeholderColor,
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
