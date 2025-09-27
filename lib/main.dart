import 'package:final_project/Constants/Themes/light_theme.dart';
import 'package:final_project/Providers/category_provider.dart';
import 'package:final_project/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/bottom_navigation_bar_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_)=>CategoryProvider())
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: AppTheme.lightTheme(context)
    );
  }
}
