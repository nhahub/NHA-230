import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/home/providers/category_provider.dart';
import 'package:tal3a/features/home/screens/search_screen.dart';
import 'package:tal3a/features/home/widgets/background_container.dart';
import 'package:tal3a/features/home/widgets/categories_card.dart';
import 'package:tal3a/features/home/widgets/place_card.dart';
import 'package:tal3a/features/home/widgets/promotion_slider.dart';

class HomeScreen extends StatelessWidget {
 const HomeScreen({super.key});

  List<Map<String, String>> getCategories(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return  [
    {'title': localizations.restaurants, 'icon': AppAssets.restaurantIcon},
    {'title': localizations.cafes, 'icon': AppAssets.coffeeIcon},
    {
      'title': localizations.malls,
      'icon': AppAssets.mallIconUnselected,
      'activeIcon': AppAssets.mallIconSelected,
    },
    {
      'title': localizations.beaches,
      'icon': AppAssets.beachIcon,
    },
    {
      'title': localizations.amusementParks,
      'icon': AppAssets.parkIcon,
    },
    {
      'title': localizations.touristAttraction,
      'icon': AppAssets.tourismAttractionIcon,
    },
  ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final categories = getCategories(context);
    return  ChangeNotifierProvider(
      create: (_) => CategoryProvider(),
      child: Scaffold(
        body: BackgroundContainer(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
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
                            localizations.goodEvening,
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
                                hintText: localizations.search,
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
              ),

              // ====== Promotion Slider ======
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    PromotionSlider(
                      imagePaths: [
                        AppAssets.promotion,
                        AppAssets.promotion,
                        AppAssets.promotion,
                      ],
                    ),
                    SizedBox(height: AppSizes.height15),

                    // ====== Categories Row ======
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
                            child: Consumer<CategoryProvider>(
                              builder: (context, categoryProvider, _) {
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(width: AppSizes.width12),
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    return CategoriesCard(
                                      title: category['title']!,
                                      iconPath: category['icon']!,
                                      activeIconPath: category['activeIcon'],
                                      index: index,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.height15),
                  ],
                ),
              ),

              // ====== Grid ======
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, _) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(categoryProvider.currentCollection)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(child: Text(localizations.noData)),
                        );
                      }

                      final items = snapshot.data!.docs;

                      return SliverPadding(
                        padding: EdgeInsets.all(AppSizes.pd20h),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final data =
                              items[index].data() as Map<String, dynamic>;
                              return PlaceCard(data: data);
                            },
                            childCount: items.length,
                          ),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
