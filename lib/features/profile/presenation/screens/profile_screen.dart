import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/profile/presenation/widgets/custom_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool isDarkMode = false;
  String currentLanguage = "English";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: AppSizes.appBarHeight,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: Text("Tal3a", style: theme.textTheme.headlineLarge),
        leading: SvgPicture.asset(
          AppAssets.appBarLeadingIcon,
          colorFilter: ColorFilter.mode(AppColors.offWhite, BlendMode.srcIn),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.pd16v),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.pd16a),
                      alignment: Alignment.center,
                      width: AppSizes.avatarWidth,
                      height: AppSizes.avatarHeight,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: AppSizes.avatarRadius,
                        backgroundImage: AssetImage(AppAssets.profileImage),
                      ),
                    ),
                    Positioned(
                      bottom: AppSizes.bottomPositioned,
                      right: AppSizes.rightPositioned,
                      child: Container(
                        width: AppSizes.avatarWidth / 5,
                        height: AppSizes.avatarHeight / 5,
                        decoration: BoxDecoration(
                          color: AppColors.offWhite,
                          border: Border.all(
                            color: AppColors.placeholderColor,
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text("Ahmed Magdy", style: theme.textTheme.headlineMedium),
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSizes.pd20h, vertical: AppSizes.pd12v),
              padding: EdgeInsets.all(AppSizes.pd12h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomListTile(
                    title: "Notifications",
                    leadingIcon: Icons.notifications_none_rounded,
                    trailing: Switch(
                      value: notificationsEnabled,
                      onChanged: (val) {
                        setState(() => notificationsEnabled = val);
                      },
                    ),
                  ),
                  CustomListTile(
                    title: "Language",
                    leadingIcon: Icons.language_rounded,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentLanguage),
                        const Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                  CustomListTile(
                    title: "Dark Mode",
                    leadingIcon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (val) {
                        setState(() {
                          isDarkMode = val;
                        });
                      },
                    ),
                  ),
                  CustomListTile(
                    title: "Account Info",
                    leadingIcon: Icons.person_outline_rounded,
                    onTap: () {},
                  ),
                  CustomListTile(
                    color: AppColors.red,
                    leadingIcon: Icons.logout,
                    title: "Log Out",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
