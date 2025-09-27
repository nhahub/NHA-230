import 'package:final_project/Constants/assets.dart';
import 'package:final_project/Constants/colors.dart';
import 'package:final_project/Utils/responsive.dart';
import 'package:final_project/Widgets/background_container.dart';
import 'package:final_project/Widgets/categories_card.dart';
import 'package:final_project/Widgets/promotion_slider.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const  HomeScreen({super.key});
  final List<Map<String, String>> categories = const [
    {'title': 'Restaurants', 'icon': AppIcons.restaurantIcon},
    {'title': 'Cafes', 'icon': AppIcons.coffeeIcon},
    {'title': 'Malls', 'icon': AppIcons.mallIconUnselected},
    {'title': 'Malls', 'icon': AppIcons.mallIconUnselected},
    {'title': 'Malls', 'icon': AppIcons.mallIconUnselected},
    {'title': 'Malls', 'icon': AppIcons.mallIconUnselected},

  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(AppImages.blueTopCircle),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Responsive(context).height(100),
                      left: Responsive(context).width(38),
                      right: Responsive(context).width(38),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: Responsive(context).height(10)),
                        SizedBox(
                          height: Responsive(context).height(80),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(
                                Icons.search,
                                color: placeholderColor,
                                size: Responsive(context).width(50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PromotionSlider(
                imagePaths: [
                  AppImages.promotion,
                  AppImages.promotion,
                  AppImages.promotion
                ]
              ),
              SizedBox(
                height: Responsive(context).height(120),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:  EdgeInsets.symmetric(horizontal: Responsive(context).width(38)),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) =>  SizedBox(width: Responsive(context).width(12)),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoriesCard(
                      title: category['title']!,
                      iconPath: category['icon']!,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
