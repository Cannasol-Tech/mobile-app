import 'package:flutter/material.dart';

class DisplayDataModel extends ChangeNotifier {
  int _bottomNavSelectedItem = 0;
  int get bottomNavSelectedItem => _bottomNavSelectedItem; 


  void setBottomNavSelectedItem(int idx){
    _bottomNavSelectedItem = idx;
    notifyListeners();
  }
}