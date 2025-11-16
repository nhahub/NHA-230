import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/data/models/user_model.dart';
import 'package:tal3a/features/place_info/presentation/screens/place_info_screen.dart';

class PlaceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String collection;
  final String placeId; // ID حقيقي من Firestore

  const PlaceCard({
    super.key,
    required this.data,
    required this.collection,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlaceInfoScreen(placeData: data)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            if (data['Image'] != null && data['Image'].toString().isNotEmpty)
              Image.network(
                data['Image'],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              )
            else
              Container(
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported),
              ),

            // أيقونة القلب
            Positioned(
              top: 10,
              right: 10,
              child: BlocBuilder<UserCubit, UserModel?>(
                builder: (context, state) {
                  final userCubit = context.read<UserCubit>();
                  final isFavorite = userCubit.isFavorite(collection, placeId);
                  return InkWell(
                    onTap: () {
                      final userCubit = context.read<UserCubit>();

                      userCubit.toggleFavorite(
                        placeId: placeId,
                        collection: collection,
                        placeData: data,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorite ? AppColors.red : AppColors.black,
                      ),
                    ),
                  );
                },
              ),
            ),

            // الاسم والتقييم
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['Name'] ?? 'Unnamed',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (data['Rating'] != null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            data['Rating'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
