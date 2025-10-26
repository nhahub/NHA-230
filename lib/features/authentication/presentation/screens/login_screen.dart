import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tal3a/features/authentication/presentation/screens/signup_screen.dart';
import 'package:tal3a/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:tal3a/services/firebase_service.dart';
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
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd36v),
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
                          if (email.text.isEmpty) {
                            snackBarKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text("Please Enter Your Email"),
                                backgroundColor: AppColors.primaryBlue,
                              ),
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseService.instance.forgetPassword(
                              email: email.text,
                            );
                            setState(() {
                              isLoading = false;
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
                        padding: EdgeInsets.symmetric(vertical: AppSizes.pd15v),
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await FirebaseService.instance
                                  .signInEmailPassword(
                                    email: email.text,
                                    password: password.text,
                                  );
                              setState(() {
                                isLoading = false;
                              });
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
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.pd15h),
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
                                "Sign in with google",
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
                            await FirebaseService.instance.signInWithGoogle();
                            setState(() {
                              isLoading = false;
                            });
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
