import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/features/profile/logic/profile_controller.dart';
import 'package:tal3a/features/profile/presentation/widgets/custom_list_tile.dart';

import '../../../../core/core.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: AppSizes.height300,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.pd16h, vertical: AppSizes.pd20v),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radius16),
          topRight: Radius.circular(AppSizes.radius16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "choose option to change photo",
            style: theme.textTheme.labelLarge,
          ),
          Row(
            children: [
              Expanded(
                child: CustomListTile(
                  title: "Camera",
                  leadingIcon: Icons.camera,
                  color: AppColors.white,
                  onTap: () async {
                    final imagePath =
                        await ProfileController.pickProfileImageFromCamera();
                    if (imagePath != null) {
                      context.read<UserCubit>().updateProfileImage(
                        File(imagePath),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              Expanded(
                child: CustomListTile(
                  title: "Gallery",
                  leadingIcon: Icons.photo_library,
                  color: AppColors.white,
                  onTap: () async {
                    final imagePath =
                        await ProfileController.pickProfileImageFromGallery();
                    if (imagePath != null) {
                      context.read<UserCubit>().updateProfileImage(
                        File(imagePath),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: CustomListTile(
              title: "Delete Photo",
              leadingIcon: Icons.delete,
              color: AppColors.white,
              onTap: () async {
                context.read<UserCubit>().deleteProfileImage();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
