import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tal3a/cubit/user_cubit.dart';
import 'package:tal3a/features/authentication/presentation/screens/signup_screen.dart';
import 'package:tal3a/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:tal3a/features/navigation/root_page.dart';
import 'package:tal3a/services/firebase_auth_service.dart';
import 'package:tal3a/services/user_repositry.dart';
import '../../../../core/core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: isloading,
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
                  padding: EdgeInsets.symmetric(horizontal: 36.w),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "Email",
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please Enter Valid Email";
                          } else {
                            return null;
                          }
                        },
                        isObsecure: false,
                        prefixIcon: Icons.email_outlined,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 36.h),
                        child: CustomTextFormField(
                          hintText: "Password",
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return "Please Enter Valid Password";
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
                              isloading = true;
                            });
                            try {
                              final isSent = await FirebaseAuthService.instance
                                  .forgetPassword(email: email.text);
                              if (isSent) {
                                snackbarKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text("Password reset email sent"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                );
                              }
                            } catch (e) {
                              snackbarKey.currentState?.showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            }
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forget Password?",
                              style: theme.textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                final credential = await FirebaseAuthService
                                    .instance
                                    .signInemailPassword(
                                      email: email.text,
                                      password: password.text,
                                    );
                                     print("*******************");
                              print("user id: ${credential?.user?.uid}");
                                if (credential?.user != null) {
                                  final userModel = await UserRepository()
                                      .getUserFromFirestore(
                                        credential?.user?.uid,
                                      );
                                  await context.read<UserCubit>().saveUser(
                                    userModel,
                                  );
                                  navigationkey.currentState?.pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const RootPage(),
                                    ),
                                  );
                                } else {
                                  snackbarKey.currentState?.showSnackBar(
                                    SnackBar(
                                      content: Text("Failed to login"),
                                      backgroundColor: AppColors.primaryBlue,
                                    ),
                                  );
                                }
                                setState(() {
                                  isloading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isloading = false;
                                });
                                snackbarKey.currentState?.showSnackBar(
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
                            "Sign in",
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
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text("OR", style: theme.textTheme.bodyLarge),
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
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: CustomElevatedButton(
                          backgroundColor: AppColors.offWhite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 15.w),
                                child: SvgPicture.asset(AppAssets.googleIcon),
                              ),
                              Text(
                                "Sign in with google",
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
                                navigationkey.currentState?.pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const RootPage(),
                                  ),
                                );
                              } else {
                                snackbarKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to login"),
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                );
                              }
                              setState(() {
                                isloading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isloading = false;
                              });
                              snackbarKey.currentState?.showSnackBar(
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
                                text: "Don't have an account?  ",
                                style: theme.textTheme.displayMedium,
                              ),
                              TextSpan(
                                text: "Sign up",
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
