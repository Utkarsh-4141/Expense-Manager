import "package:flutter/material.dart";

class Category extends ChangeNotifier {
  List<Map<String, dynamic>> categoryList;

  Category({required this.categoryList});

  void changeData(List<Map<String, dynamic>> categoryList) {
    this.categoryList = categoryList;
    notifyListeners();
  }

  void addCategory(Map<String, dynamic> newCategory) {
    categoryList.add(newCategory);
    notifyListeners();
  }
}
