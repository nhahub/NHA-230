import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/profile/presentation/widgets/custom_list_tile.dart';

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
          height: AppSizes.height200,
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
                padding: EdgeInsets.symmetric(vertical: AppSizes.pd12v),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.pd16a),
                      alignment: Alignment.center,
                      width: AppSizes.width600,
                      height: AppSizes.height600,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: AppSizes.radius300,
                        backgroundImage: AssetImage(AppAssets.profileImage),
                      ),
                    ),
                    Positioned(
                      bottom: AppSizes.height25,
                      right: AppSizes.width25,
                      child: Container(
                        width: AppSizes.width600/ 5,
                        height: AppSizes.height600/ 5,
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          border: Border.all(
                            color: AppColors.placeholderColor,
                            width: AppSizes.width1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.offWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text("Ahmed Magdy", style: theme.textTheme.headlineMedium),
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSizes.pd36h, vertical: AppSizes.pd32v),
              padding: EdgeInsets.all(AppSizes.pd12a),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppSizes.radius16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: AppSizes.width10,
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
                  Consumer<ThemeCubit>(
                    builder: (BuildContext context, ThemeCubit themeCubit, Widget? child) {
                      return CustomListTile(
                        title: "Dark Mode",
                        leadingIcon: Icons.dark_mode_outlined,
                        trailing: Switch(
                          value: themeCubit.state.isDark,
                          onChanged: (val) {
                            themeCubit.toggleTheme();
                          },
                        ),
                      );
                    },
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
