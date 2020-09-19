import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends ChangeNotifier {
  Color hidup = Colors.white;
  Color mati = Color(0xFF4A6572);

  ThemeBloc() {
    tampilwarna();
  }
  getWarna(String color) {
    switch (color) {
      case 'hidup':
        {
          this.hidup = Colors.white;
          notifyListeners();
          break;
        }
      default:
        {
          this.hidup = Color(0xFF4A6572);
          notifyListeners();
          break;
        }
    }
  }
  Future tampilwarna() async {
    getWarna('hidup');
  }
}