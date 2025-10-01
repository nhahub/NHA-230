import 'package:final_project/Constants/app_colors.dart';
import 'package:final_project/Utils/responsive.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;
  final bool isObsecure;
  final IconButton? suffixIcon;
  final IconData prefixIcon;
  final String hintText;

  const CustomTextFormField({
    super.key,
    this.suffixIcon,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.isObsecure,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObsecure,
      validator: validator,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyLarge,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Responsive(context).width(8),
        ),
        errorStyle: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
        filled: true,
        fillColor: AppColors.offWhite,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ), // Border radius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ), // Border radius
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColor, 
            width: 2.0, 
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ), // Border radius
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2.0, 
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ), // Border radius
        ),
        suffixIcon: (suffixIcon != null) ? suffixIcon! : null,
        prefixIcon: Icon(prefixIcon,color: theme.primaryColor,),
      ),
    );
  }
}
