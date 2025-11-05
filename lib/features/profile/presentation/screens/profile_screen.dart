import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/cubit/localization/local_state.dart';
import 'package:tal3a/cubit/localization/locale_cubit.dart';
import 'package:tal3a/cubit/theme/theme_cubit.dart';
import 'package:tal3a/cubit/theme/theme_state.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/data/models/user_model.dart';
import 'package:tal3a/features/profile/presentation/widgets/custom_bottom_sheet.dart';
import 'package:tal3a/features/profile/presentation/widgets/custom_list_tile.dart';
import 'package:tal3a/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:tal3a/services/user_repositry.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<UserCubit>().state;
    usernameController.text = user?.username ?? 'username';
  }

  bool notificationsEnabled = true;
  bool isDarkMode = false;
  bool isEditing = false;
  String currentLanguage = "";
  String langCode = "en";
  TextEditingController usernameController = TextEditingController();
  FocusNode textFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          height: AppSizes.height200,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: Text(localizations.tal3a, style: theme.textTheme.headlineLarge),
        leading: SvgPicture.asset(
          AppAssets.appBarLeadingIcon,
          colorFilter: ColorFilter.mode(AppColors.offWhite, BlendMode.srcIn),
        ),
      ),
      body: BlocConsumer<UserCubit, UserModel?>(
        listener: (context, user) {
          if (user?.profileImagePath != null &&
              user!.profileImagePath!.isNotEmpty) {
            snackBarKey.currentState?.showSnackBar(
              SnackBar(content: Text(localizations.profileUpdated)),
            );
          }
        },
        builder: (context, user) {
          if (!isEditing) {
            usernameController.text = user?.username ?? 'username';
          }
          return SingleChildScrollView(
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
                            key: UniqueKey(),
                            radius: AppSizes.radius300,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                (user?.profileImagePath != null &&
                                    user!.profileImagePath!.isNotEmpty &&
                                    File(user.profileImagePath!).existsSync())
                                ? FileImage(File(user.profileImagePath!))
                                      as ImageProvider
                                : null,
                            child:
                                (user?.profileImagePath == null ||
                                    user!.profileImagePath!.isEmpty ||
                                    !File(user.profileImagePath!).existsSync())
                                ? Icon(
                                    Icons.person,
                                    size: AppSizes.radius300,
                                    color: AppColors.black,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: AppSizes.height25,
                          right: AppSizes.width25,
                          child: Container(
                            width: AppSizes.width600 / 5,
                            height: AppSizes.height600 / 5,
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              border: Border.all(
                                color: AppColors.placeholderColor,
                                width: 1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.black,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) => CustomBottomSheet(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        enabled: isEditing,
                        focusNode: textFocus,
                        controller: usernameController,
                        textAlign: TextAlign.end,
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (isEditing &&
                            usernameController.text.trim().isNotEmpty) {
                          String newUsername = usernameController.text.trim();
                          await context.read<UserCubit>().updateUserName(
                            newUsername,
                          );
                          UserRepository().updateUsername(
                            user!.copyWith(username: newUsername),
                          );
                          textFocus.unfocus();
                        } else {
                          usernameController.text =
                              user?.username ?? 'username';
                        }
                        setState(() {
                          isEditing = !isEditing;
                        });
                        if (isEditing) {
                          Future.delayed(Duration(milliseconds: 100), () {
                            textFocus.requestFocus();
                          });
                        }
                      },
                      icon: Icon(
                        isEditing ? Icons.check : Icons.edit,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.pd36h,
                    vertical: AppSizes.pd32v,
                  ),
                  padding: EdgeInsets.all(AppSizes.pd12a),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radius16),
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
                        title: localizations.notifications,
                        leadingIcon: Icons.notifications_none_rounded,
                        trailing: Switch(
                          value: notificationsEnabled,
                          onChanged: (val) {
                            setState(() => notificationsEnabled = val);
                          },
                        ),
                      ),
                      BlocBuilder<LocaleCubit, LocaleState>(
                        builder: (context, state) {
                          currentLanguage = state.locale.languageCode == "en"
                              ? localizations.english
                              : localizations.arabic;
                          return CustomListTile(
                            title: localizations.language,
                            leadingIcon: Icons.language_rounded,
                            onTap: () {
                              String newLangCode =
                                  state.locale.languageCode == "en"
                                  ? "ar"
                                  : "en";
                              LocaleCubit().toggleLocale(newLangCode);
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.locale.languageCode == "en"
                                      ? localizations.english
                                      : localizations.arabic,
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return CustomListTile(
                            title: localizations.darkMode,
                            leadingIcon: Icons.dark_mode_outlined,
                            trailing: Switch(
                              value: state.isDark,
                              onChanged: (val) {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            ),
                          );
                        },
                      ),
                      CustomListTile(
                        color: AppColors.red,
                        leadingIcon: Icons.logout,
                        title: localizations.darkMode,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => LogoutDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
