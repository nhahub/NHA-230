
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/features/home/providers/category_provider.dart';
import 'package:tal3a/features/home/screens/search_screen.dart';
import 'package:tal3a/features/home/widgets/background_container.dart';
import 'package:tal3a/features/home/widgets/categories_card.dart';
import 'package:tal3a/features/home/widgets/promotion_slider.dart';

import '../../../core/core.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> categories = [
    {'title': 'Restaurants', 'icon': AppAssets.restaurantIcon},
    {'title': 'Cafes', 'icon': AppAssets.coffeeIcon},
    {
      'title': 'Malls',
      'icon': AppAssets.mallIconUnselected,
      'activeIcon': AppAssets.mallIconSelected,
    },
    {
      'title': 'Malls',
      'icon': AppAssets.mallIconUnselected,
      'activeIcon': AppAssets.mallIconSelected,
    },
    {
      'title': 'Malls',
      'icon': AppAssets.mallIconUnselected,
      'activeIcon': AppAssets.mallIconSelected,
    },
    {
      'title': 'Malls',
      'icon': AppAssets.mallIconUnselected,
      'activeIcon': AppAssets.mallIconSelected,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(AppAssets.blueTopCircle),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 110.h,
                      left: 38.w,
                      right: 38.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 30.w),
                        SizedBox(
                          height: 100.w,
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchScreen(),
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.placeholderColor,
                                size: 50.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PromotionSlider(imagePaths: [AppAssets.promotion, AppAssets.promotion, AppAssets.promotion]),
              SizedBox(height: 15.h),
              Row(
                children: [
                  SizedBox(width: 38.w),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list,
                      size: 80.w,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 95.h,
                      child: ChangeNotifierProvider(
                        create: (_) => CategoryProvider(),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => SizedBox(width: 12.w),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoriesCard(
                              title: category['title']!,
                              iconPath: category['icon']!,
                              activeIconPath: category['activeIcon'],
                              index: index,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
