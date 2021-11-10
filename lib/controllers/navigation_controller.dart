import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/pages/add_user_screen/add_user_screen.dart';
import 'package:sportiwe_admin/pages/authentication/login_screen.dart';
import 'package:sportiwe_admin/pages/coupon_code/coupon_code_screen.dart';
import 'package:sportiwe_admin/pages/dashboard/dashboard_screen.dart';
import 'package:sportiwe_admin/pages/edit_user_screen/edit_user_screen.dart';
import 'package:sportiwe_admin/pages/main/main_screen.dart';
import 'package:sportiwe_admin/pages/reports/reports_screen.dart';
import 'package:sportiwe_admin/pages/splashscreen.dart';
import 'package:sportiwe_admin/pages/users_list_screen/users_list_screen.dart';
import 'package:sportiwe_admin/pages/venues_list_screen/venues_list_screen.dart';

class NavigationController {
  static NavigationController? _instance;

  factory NavigationController() {
    if(_instance == null) {
      _instance = NavigationController._();
    }
    return _instance!;
  }

  NavigationController._();

  GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

  Route getHomeNavigatorRoutes(RouteSettings settings) {
    switch(settings.name) {
      case AddUserScreen.routeName:
        return CupertinoPageRoute(builder: (_) => AddUserScreen());
      case EditUserScreen.routeName:
        return CupertinoPageRoute(builder: (_) => EditUserScreen(), settings: settings);
      case UsersListScreen.routeName:
        return CupertinoPageRoute(builder: (_) => UsersListScreen());
      case VenuesListScreen.routeName:
        return CupertinoPageRoute(builder: (_) => VenuesListScreen());
      case DashboardScreen.routeName:
        return CupertinoPageRoute(builder: (_) => DashboardScreen());
      case CouponCodeScreen.routeName:
        return CupertinoPageRoute(builder: (_) => CouponCodeScreen());
      case ReportScreen.routeName:
        return CupertinoPageRoute(builder: (_) => ReportScreen());
      default:
        return CupertinoPageRoute(builder: (_) => AddUserScreen());
    }
  }

  Route getMainNavigatorRoutes(RouteSettings settings) {
    switch(settings.name) {
      case SplashScreen.routeName:
        return CupertinoPageRoute(builder: (_) => SplashScreen());
      case LoginScreen.routeName:
        return CupertinoPageRoute(builder: (_) => LoginScreen());
      case MainScreen.routeName:
        return CupertinoPageRoute(builder: (_) => MainScreen());
      default:
        return CupertinoPageRoute(builder: (_) => SplashScreen());
    }
  }

}