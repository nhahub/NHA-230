import 'package:final_project/Constants/app_colors.dart';
import 'package:final_project/Constants/assets.dart';
import 'package:final_project/Screens/login_screen.dart';
import 'package:final_project/Utils/responsive.dart';
import 'package:final_project/Widgets/custom_elevated_button.dart';
import 'package:final_project/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0XFFFAEA00),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Image.asset(AppImages.signupImage),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive(context).width(36),
                ),
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: "Full Name",
                      controller: name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Your Name";
                        } else {
                          return null;
                        }
                      },
                      isObsecure: false,
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive(context).height(36),
                      ),
                      child: CustomTextFormField(
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
                    ),
                    CustomTextFormField(
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive(context).height(36),
                      ),
                      child: CustomTextFormField(
                        hintText: "Confirm Password",
                        controller: confirmPassword,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return "Please Enter Valid Password";
                          } else if (value != password.text) {
                            return "Unmatched Fields";
                          } else {
                            return null;
                          }
                        },
                        isObsecure: false,
                        prefixIcon: Icons.lock,
                      ),
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          //*login logic here
                        }
                      },
                      backgroundColor: theme.primaryColor,
                      child: Text(
                        "Sign up",
                        style: theme.textTheme.displayLarge,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive(context).height(15),
                      ),
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
                              horizontal: Responsive(context).width(15),
                            ),
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
                    ),
                    CustomElevatedButton(
                      backgroundColor: AppColors.offWhite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: Responsive(context).width(15),
                            ),
                            child: SvgPicture.asset("assets/icons/google.svg"),
                          ),
                          Text(
                            "Sign up with google",
                            style: theme.textTheme.displayLarge!.copyWith(
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        //*sign with google logic
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Responsive(context).height(15),),
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
                                text: "Already have an account?  ",
                                style: theme.textTheme.displayMedium
                              ),
                              TextSpan(
                                text: "Sign in",
                                style: theme.textTheme.displaySmall
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
    );
  }
}
