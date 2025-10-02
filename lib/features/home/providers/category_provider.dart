import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  int selectedIndex = 0;

  void select(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
