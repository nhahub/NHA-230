import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/features/home/widgets/place_card.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();
    final favIds = userCubit.favoritePlacesIds;
    final localizations = AppLocalizations.of(context)!;

    if (favIds.isEmpty) {
      return Scaffold(
        appBar:  AppBar(
          flexibleSpace: Container(
            height: AppSizes.height200,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          ),
          title: Text(
            localizations.likedPlaces,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w100,
              fontSize: AppSizes.width64,
            ),
          ),
        ),
        body: Center(child: Text(localizations.noLikedPlaces)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: AppSizes.height200,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: Text(
          localizations.likedPlaces,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w100,
            fontSize: AppSizes.width64,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchLikedPlaces(favIds),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final places = snapshot.data!;
          if (places.isEmpty) {
            return Center(child: Text(localizations.noLikedPlaces));
          }

          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final item = places[index];

              return PlaceCard(
                data: item['data'],
                collection: item['collection'],
                placeId: item['placeId'],
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchLikedPlaces(List<String> ids) async {
    List<Map<String, dynamic>> result = [];

    for (var docId in ids) {
      try {
        final parts = docId.split("_");
        final collection = parts[0];
        final placeId = parts[1];

        final doc = await FirebaseFirestore.instance
            .collection(collection)
            .doc(placeId)
            .get();

        if (doc.exists) {
          result.add({
            "collection": collection,
            "placeId": placeId,
            "data": doc.data(),
          });
        }
      } catch (e) {
        continue;
      }
    }

    return result;
  }
}
