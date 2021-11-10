import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/controllers/providers/home_page_provider.dart';
import 'package:sportiwe_admin/pages/add_user_screen/add_user_screen.dart';
import 'package:sportiwe_admin/pages/coupon_code/coupon_code_screen.dart';
import 'package:sportiwe_admin/pages/dashboard/dashboard_screen.dart';
import 'package:sportiwe_admin/pages/reports/reports_screen.dart';
import 'package:sportiwe_admin/pages/users_list_screen/users_list_screen.dart';
import 'package:sportiwe_admin/pages/venues_list_screen/venues_list_screen.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  GlobalKey key = GlobalKey();
  bool isFirst =  true;

  Widget? addUserScreen, usersListScreen, venuesListScreen, dashboardScreen, coupanCodeScreen,reportScreen;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      key: key,
      physics: NeverScrollableScrollPhysics(),
      controller: Provider.of<HomePageProvider>(context).pageController,
      children: [
        getAddUserScreen(),
        getUsersListScreen(),
        getVenuesListScreen(),
        getDashboardScreen(),
        getCoupanCodeScreen(),
        getReportScreen()
      ],
    );
  }

  Widget getAddUserScreen() {
    if (addUserScreen == null) addUserScreen = AddUserScreen();
    return addUserScreen!;
  }

  Widget getUsersListScreen() {
    if (usersListScreen == null) usersListScreen = UsersListScreen();
    return usersListScreen!;
  }

  Widget getVenuesListScreen() {
    if (venuesListScreen == null) venuesListScreen = VenuesListScreen();
    return venuesListScreen!;
  }

  Widget getDashboardScreen() {
    if (dashboardScreen == null) dashboardScreen = DashboardScreen();
    return dashboardScreen!;
  }

  Widget getCoupanCodeScreen() {
    if (coupanCodeScreen == null) coupanCodeScreen = CouponCodeScreen();
    return coupanCodeScreen!;
  }
  
  Widget getReportScreen() {
    if (reportScreen == null) reportScreen = ReportScreen();
    return reportScreen!;
  }

  @override
  bool get wantKeepAlive => true;


}
