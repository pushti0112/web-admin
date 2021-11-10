import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/controllers/app_controller.dart';
import 'package:sportiwe_admin/controllers/navigation_controller.dart';
import 'package:sportiwe_admin/controllers/providers/coupon_code_provider.dart';
import 'package:sportiwe_admin/controllers/providers/data_provider.dart';
import 'package:sportiwe_admin/controllers/providers/home_page_provider.dart';
import 'package:sportiwe_admin/controllers/providers/menu_provider.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/controllers/providers/venue_provider.dart';
import 'package:sportiwe_admin/pages/splashscreen.dart';

class MyApp extends StatelessWidget {
  bool isDev;

  MyApp({required this.isDev});

  @override
  Widget build(BuildContext context) {
    AppController().isDev = isDev;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => CompanyUserProvider()),
        ChangeNotifierProvider(create: (_) => VenueProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => CouponCodeProvider()),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: AppController().isDev!,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      onGenerateRoute: NavigationController().getMainNavigatorRoutes,
    );
  }
}

