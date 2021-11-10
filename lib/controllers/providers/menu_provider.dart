import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
    else {
      Navigator.pop(_scaffoldKey.currentContext!);
    }
  }

  int index = 0;

}