import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';

class InfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String? value;

  const InfoItemWidget({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
