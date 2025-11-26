import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/data/models/user_model.dart';
import 'package:tal3a/features/authentication/presentation/screens/login_screen.dart';
import 'package:tal3a/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:tal3a/features/navigation/root_page.dart';
import 'package:tal3a/services/firebase_auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.yellow,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset(AppAssets.signupImage),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.pd36h),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: localizations.nameLabel,
                        controller: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return localizations.enterName;
                          } else {
                            return null;
                          }
                        },
                        isObsecure: false,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd36v),
                        child: CustomTextFormField(
                          hintText: localizations.emailLabel,
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains("@")) {
                              return localizations.invalidEmail;
                            } else {
                              return null;
                            }
                          },
                          isObsecure: false,
                          prefixIcon: Icons.email_outlined,
                        ),
                      ),
                      CustomTextFormField(
                        hintText: localizations.passwordLabel,
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return localizations.invalidPassword;
                          } else {
                            return null;
                          }
                        },
                        isObsecure: false,
                        prefixIcon: Icons.lock,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd36v),
                        child: CustomTextFormField(
                          hintText: localizations.confirmPasswordLabel,
                          controller: confirmPassword,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return localizations.invalidPassword;
                            } else if (value != password.text) {
                              return localizations.passwordsNotMatch;
                            } else {
                              return null;
                            }
                          },
                          isObsecure: false,
                          prefixIcon: Icons.lock,
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              final credintal = await FirebaseAuthService
                                  .instance
                                  .signUpemailPassword(
                                    username: name.text,
                                    email: email.text,
                                    password: password.text,
                                  );
                              if (credintal != null) {
                                
                                final userModel = UserModel.fromFirebase(
                                  credintal.user!,
                                );
                                
                                

                                await context.read<UserCubit>().saveUser(
                                  userModel,
                                );

                               
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => RootPage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                setState(() {
                                  isloading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(localizations.errorTryAgain),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isloading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            }
                          }
                        },
                        backgroundColor: theme.primaryColor,
                        child: Text(
                          localizations.signupButton,
                          style: theme.textTheme.displayLarge,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd15v),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: theme.primaryColor,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.pd15h,
                              ),
                              child: Text(
                                localizations.or,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: theme.primaryColor,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomElevatedButton(
                        backgroundColor: AppColors.offWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: AppSizes.pd15h),
                              child: SvgPicture.asset(AppAssets.googleIcon),
                            ),
                            Text(
                              localizations.gooleSignUp,
                              style: theme.textTheme.displayLarge!.copyWith(
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            final credintal = await FirebaseAuthService.instance
                                .signUpWithGoogle();
                            if (credintal != null) {
                              final userModel = UserModel.fromFirebase(
                                credintal.user!,
                              );
                              await context.read<UserCubit>().saveUser(
                                userModel,
                              );
                              setState(() {
                                isloading = false;
                              });

                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => RootPage(),
                                ),
                                (route) => false,
                              );
                            } else {
                              setState(() {
                                isloading = false;
                              });

                              snackBarKey.currentState?.showSnackBar(
                                SnackBar(
                                  content: Text(localizations.errorTryAgain),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isloading = false;
                            });
                            snackBarKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                duration: Duration(seconds: 2),
                                backgroundColor: AppColors.primaryBlue,
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd15v),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: localizations.haveAccount,
                                  style: theme.textTheme.displaySmall!.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: localizations.loginButton,
                                  style: theme.textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
