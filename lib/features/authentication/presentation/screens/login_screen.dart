import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/features/authentication/presentation/screens/signup_screen.dart';
import 'package:tal3a/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:tal3a/features/navigation/root_page.dart';
import 'package:tal3a/services/firebase_auth_service.dart';
import 'package:tal3a/services/user_repositry.dart';
import 'package:tal3a/core/core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.yellow,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset(AppAssets.loginImage),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.pd36h),
                  child: Column(
                    children: [
                      CustomTextFormField(
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd36v),
                        child: CustomTextFormField(
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
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final isSent = await FirebaseAuthService.instance
                                  .forgetPassword(email: email.text);
                              if (isSent) {
                                snackBarKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text(localizations.resetPasswordSent),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                );
                              }
                            } catch (e) {
                              snackBarKey.currentState?.showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              localizations.forgotPassword,
                              style: theme.textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd15v),
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                final credential = await FirebaseAuthService
                                    .instance
                                    .signInEmailPassword(
                                      email: email.text,
                                      password: password.text,
                                    );

                                if (credential?.user != null) {
                                  final userModel = await UserRepository()
                                      .getUserFromFirestore(
                                        credential?.user?.uid,
                                      );
                                  await context.read<UserCubit>().saveUser(
                                    userModel,
                                  );
                                  navigationKey.currentState?.pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const RootPage(),
                                    ),
                                  );
                                } else {
                                  snackBarKey.currentState?.showSnackBar(
                                    SnackBar(
                                      content: Text(localizations.errorTryAgain),
                                      backgroundColor: AppColors.primaryBlue,
                                    ),
                                  );
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                snackBarKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                );
                              }
                            }
                          },
                          backgroundColor: theme.primaryColor,
                          child: Text(
                            localizations.loginButton,
                            style: theme.textTheme.displayLarge,
                          ),
                        ),
                      ),
                      Row(
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
                            child: Text(localizations.or, style: theme.textTheme.bodyLarge),
                          ),
                          Expanded(
                            child: Divider(
                              color: theme.primaryColor,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd15v),
                        child: CustomElevatedButton(
                          backgroundColor: AppColors.offWhite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: AppSizes.pd15h),
                                child: SvgPicture.asset(AppAssets.googleIcon),
                              ),
                              Text(
                                localizations.googleSignIn,
                                style: theme.textTheme.displayLarge!.copyWith(
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final credential = await FirebaseAuthService
                                  .instance
                                  .signInWithGoogle();

                              if (credential?.user != null) {
                                final userModel = await UserRepository()
                                    .getUserFromFirestore(
                                      credential!.user!.uid,
                                    );
                                await context.read<UserCubit>().saveUser(
                                  userModel,
                                );
                                navigationKey.currentState?.pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const RootPage(),
                                  ),
                                );
                              } else {
                                snackBarKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text(localizations.errorTryAgain,),
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              snackBarKey.currentState?.showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: localizations.noAccount,
                                style: theme.textTheme.displayMedium,
                              ),
                              TextSpan(
                                text: localizations.signupButton,
                                style: theme.textTheme.displaySmall,
                              ),
                            ],
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
