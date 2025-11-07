import 'package:flutter/material.dart';
import 'package:tal3a/core/core.dart' show AppSizes;

class PlaceImageWidget extends StatelessWidget {
  final String imageUrl;

  const PlaceImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: double.infinity,
          height: AppSizes.height600,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: AppSizes.height200,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
