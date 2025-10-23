import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/home/providers/category_provider.dart';

class CategoriesCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? activeIconPath;
  final int index;

  const CategoriesCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.activeIconPath,
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
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Card(
              color: isSelected ? AppColors.white : AppColors.offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryBlue : AppColors.offWhite,
                  width: 4.w,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 35.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      isSelected && activeIconPath != null
                          ? activeIconPath!
                          : iconPath,
                      width: 50.w,
                    ),
                    SizedBox(width: 15.w),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? AppColors.primaryBlue : AppColors.placeholderColor,
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
