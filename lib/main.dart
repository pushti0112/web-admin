import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sportiwe_admin/controllers/app_controller.dart';
import 'package:sportiwe_admin/pages/myapp.dart';

void main() async {
  await Firebase.initializeApp();
  await AppController().getThemeMode();
  runApp(MyApp(isDev: false,));
}

