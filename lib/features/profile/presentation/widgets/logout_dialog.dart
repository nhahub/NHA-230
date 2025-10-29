import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/cubit/user/user_cubit.dart';
import 'package:tal3a/features/authentication/presentation/screens/login_screen.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        "Logout",
        style: theme.textTheme.labelMedium!.copyWith(color: AppColors.red),
      ),
      content: Text(
        "Are you sure you want to logout?",
        style: theme.textTheme.labelMedium,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel", style: theme.textTheme.labelMedium),
        ),
        TextButton(
          onPressed: () async {
            context.read<UserCubit>().clearUser();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          child: Text(
            "Logout",
            style: theme.textTheme.labelMedium!.copyWith(
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
