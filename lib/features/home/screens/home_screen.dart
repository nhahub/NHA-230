import 'package:final_project/core/constants/app_assets.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/home/providers/category_provider.dart';
import 'package:final_project/features/home/widgets/background_container.dart';
import 'package:final_project/features/home/widgets/categories_card.dart';
import 'package:final_project/features/home/widgets/promotion_slider.dart';
import 'package:final_project/features/home/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> categories = const [
    {'title': 'Restaurants', 'icon': restaurantIcon},
    {'title': 'Cafes', 'icon': coffeeIcon},
    {
      'title': 'Malls',
      'icon': mallIconUnselected,
      'activeIcon': mallIconSelected,
    },
    {
      'title': 'Malls',
      'icon': mallIconUnselected,
      'activeIcon': mallIconSelected,
    },
    {
      'title': 'Malls',
      'icon': mallIconUnselected,
      'activeIcon': mallIconSelected,
    },
    {
      'title': 'Malls',
      'icon': mallIconUnselected,
      'activeIcon': mallIconSelected,
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
                  Image.asset(blueTopCircle),
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
                                color: placeholderColor,
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
              PromotionSlider(imagePaths: [promotion, promotion, promotion]),
              SizedBox(height: 15.h),
              Row(
                children: [
                  SizedBox(width: 38.w),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list,
                      size: 80.w,
                      color: primaryBlue,
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
