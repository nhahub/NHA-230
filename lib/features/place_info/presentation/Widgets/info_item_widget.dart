import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';

class InfoItemWidget extends StatelessWidget {
  final String label;
  final String? value;

  const InfoItemWidget({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.height8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
              fontSize: AppSizes.width56,
            ),
          ),
          Expanded(
            child: Text(
              value!,
              style: TextStyle(
                color: Colors.black,
                fontSize: AppSizes.width48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
