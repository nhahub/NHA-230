import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/features/home/providers/category_provider.dart';
import 'package:tal3a/features/home/screens/search_screen.dart';
import 'package:tal3a/features/home/widgets/background_container.dart';
import 'package:tal3a/features/home/widgets/categories_card.dart';
import 'package:tal3a/features/home/widgets/promotion_slider.dart';
import 'package:tal3a/core/core.dart';


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
                      top: AppSizes.height110,
                      left: AppSizes.width38,
                      right: AppSizes.width38,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: AppSizes.height10),
                        SizedBox(
                          height: AppSizes.height100,
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
                                size: AppSizes.radius50,
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
              SizedBox(height: AppSizes.height15),
              Row(
                children: [
                  SizedBox(width: AppSizes.width38),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list,
                      size: AppSizes.radius80,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: AppSizes.height95,
                      child: ChangeNotifierProvider(
                        create: (_) => CategoryProvider(),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => SizedBox(width: AppSizes.width12),
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
