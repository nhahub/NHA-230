import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:tal3a/features/place_info/presentation/screens/place_info_screen.dart';

class PlaceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  PlaceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceInfoScreen(placeData: data),
          ),
        );
    },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius20),
        ),
        elevation: 3,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // ===== الخلفية =====
            if (data['Image'] != null && data['Image'].toString().isNotEmpty)
              Image.network(
                data['Image'],
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),

            // ===== أيقونة القلب =====
            Positioned(
              top: 10,
              right: 10,
              child: ValueListenableBuilder<bool>(
                valueListenable: isFavoriteNotifier,
                builder: (context, isFavorite, _) {
                  return GestureDetector(
                    onTap: () =>
                    isFavoriteNotifier.value = !isFavoriteNotifier.value,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorite ? AppColors.red : AppColors.black,
                        size: 60.w,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ===== الاسم والتقييم =====
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // الاسم
                    Expanded(
                      child: Text(
                        data['Name'] ?? 'Unnamed',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 45.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // التقييم
                    if (data['Rating'] != null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 55.w),
                          const SizedBox(width: 4),
                          Text(
                            data['Rating'].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 45.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
