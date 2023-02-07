import 'package:flutter/material.dart';

// Custom Colors
abstract class CColors {
  static const white = Color(0xffFFFFFF);
  static const black = Color(0xff1c1c1c);
  static const darkGray = Color(0xff2b2b2b);
  static const lightGray = Color(0xff727880);
  static const bottomNavBar = Color(0xff232229);
  static const blue = Color(0xff4680fe);
  static const purple = Color(0xffcfb9ff);
  static const yellow = Color(0xffffd98f);
  static const green = Color(0xff4ED2A0);
  static const pink = Color(0xffff8fc0);
  static const peach = Color(0xffffaa99);
  static const darkPeach = Color(0xffff9985);
  static const salad = Color(0xffc3e388);
  static const pastelBlue = Color(0xff8cb1ff);

  static Color getCategoryColor(String category) {
    Color categoryColor = CColors.salad;
    switch (category) {
      case "SPORT":
        categoryColor = CColors.green;
        break;
      case "WORK":
        categoryColor = CColors.purple;
        break;
      case "HOBBY":
        categoryColor = CColors.peach;
        break;
      case "MEETING":
        categoryColor = CColors.pastelBlue;
        break;
      case "PERSONAL":
        categoryColor = CColors.pink;
        break;
      case "ROUTINE":
        categoryColor = CColors.yellow;
        break;
      default:
        categoryColor = CColors.salad;
    }
    return categoryColor;
  }
}
