import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  int selectedIndex = 0;
  String currentCollection = 'Restaurants';

  void select(int index, String collectionName) {
    selectedIndex = index;
    currentCollection = collectionName;
    notifyListeners();
  }
}
