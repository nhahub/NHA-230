import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:splash_screen/core/constants/app_assets.dart';
import 'package:splash_screen/core/constants/colors.dart';
import 'package:splash_screen/features/authentication/signup_screen.dart';
import 'package:splash_screen/features/home/widgets/custom_elevated_button.dart';
import 'package:splash_screen/features/home/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
              Image.asset(loginImage),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 36.w,
                ),
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
                      padding: EdgeInsets.symmetric(
                        vertical: 36.h
                      ),
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
                      onTap: (){
                        //*forget password logic here
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Text("Forget Password?", style: theme.textTheme.displaySmall,)
                      ],),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric( vertical:15.h),
                      child: CustomElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            //*login logic here
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
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
                    Padding(
                      padding: EdgeInsets.symmetric( vertical:15.h,),
                      child: CustomElevatedButton(
                        backgroundColor: offWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 15.w,
                              ),
                              child: SvgPicture.asset("assets/icons/google.svg"),
                            ),
                            Text(
                              "Sign in with google",
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
    );
  }
}
