import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    this.onTap,
    this.trailing,
    this.color,
    required this.title,
    required this.leadingIcon,
  });

  final String title;
  final IconData leadingIcon;
  final Widget? trailing;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title, style: theme.textTheme.labelMedium!.copyWith(color: color)),
      leading: Icon(leadingIcon, color: color ?? theme.iconTheme.color),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
