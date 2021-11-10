import 'package:flutter/material.dart';
import 'package:sportiwe_admin/controllers/app_controller.dart';

class Styles {
  static Color red = Color(0XFFFF0013);
  static Color black = Color(0XFF221F1E);
  static Color green = Color(0XFF92E3A9);
  static Color grey = Color(0XFFC3C3C3);
  static Color white = Color(0XFFFFFFFF);
  static Color blue = Color(0XFF0A2749);
  static Color facebook = Color(0XFF3B5998);
  static Color background = Color(0XFFE5E5E5);

  static String MONTSERRAT_BLACK = 'Montserrat-Black';
  static String MONTSERRAT_BOLD = 'Montserrat-Bold';
  static String MONTSERRAT_EXTRABOLD = 'Montserrat-ExtraBold';
  static String MONTSERRAT_EXTRALIGHT = 'Montserrat-ExtraLight';
  static String MONTSERRAT_LIGHT = 'Montserrat-Light';
  static String MONTSERRAT_MEDIUM = 'Montserrat-Medium';
  static String MONTSERRAT_REGULAR = 'Montserrat-Regular';
  static String MONTSERRAT_SEMIBOLD = 'Montserrat-SemiBold';
  static String MONTSERRAT_THIN = 'Montserrat-Thin';



  static Color getAppBackgroundColor() {
    return AppController().isLightTheme! ? white : black;
  }
}