import 'package:final_project/Constants/assets.dart';
import 'package:final_project/features/authentication/signup_screen.dart';
import 'package:final_project/features/home/widgets/custom_elevated_button.dart';
import 'package:final_project/features/home/widgets/custom_text_form_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              Image.asset(AppImages.loginImage),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive(context).width(36),
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
                        vertical: Responsive(context).height(36),
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
                      padding: EdgeInsets.symmetric( vertical: Responsive(context).height(15),),
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
                    Padding(
                      padding: EdgeInsets.symmetric( vertical: Responsive(context).height(15),),
                      child: CustomElevatedButton(
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
