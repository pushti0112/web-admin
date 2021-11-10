import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/controllers/providers/home_page_provider.dart';
import 'package:sportiwe_admin/controllers/providers/menu_provider.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/pages/add_user_screen/add_user_screen.dart';
import 'package:sportiwe_admin/pages/coupon_code/coupon_code_screen.dart';
import 'package:sportiwe_admin/pages/dashboard/dashboard_screen.dart';
import 'package:sportiwe_admin/pages/reports/reports_screen.dart';
import 'package:sportiwe_admin/pages/users_list_screen/users_list_screen.dart';
import 'package:sportiwe_admin/pages/venues_list_screen/venues_list_screen.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  void onPress(BuildContext context, String title, String routeName, int index) {
    //print("Context:${context}, Title:${title}, RouteName:${routeName}");

    NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.selectedPageTitle = title;
    navigationProvider.notifyListeners();

    Provider.of<HomePageProvider>(context,listen: false).setIndex(index);
    //Navigator.popAndPushNamed(NavigationController().homeNavigatorKey.currentContext!, routeName);

    MenuProvider menuProvider = Provider.of<MenuProvider>(context, listen: false);
    if(!Responsive.isDesktop(menuProvider.scaffoldKey.currentContext!)) Provider.of<MenuProvider>(context, listen: false).controlMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: AddUserScreen.title,
            iconData: Icons.person_add,
            routename: AddUserScreen.routeName,
            press: onPress,
            index: 0,
            // press: (){
            //   Provider.of<HomePageProvider>(context,listen: false).setIndex(2);
            // },
          ),
          DrawerListTile(
            title: UsersListScreen.title,
            iconData: Icons.people_alt,
            routename: UsersListScreen.routeName,
            press: onPress,
            index: 1,
          ),
          DrawerListTile(
            title: VenuesListScreen.title,
            iconData: Icons.vertical_distribute,
            routename: VenuesListScreen.routeName,
            press: onPress,
            index: 2,
          ),
          DrawerListTile(
            title: DashboardScreen.title,
            iconData: Icons.dashboard,
            routename: DashboardScreen.routeName,
            press: onPress,
            index: 3,
          ),
          DrawerListTile(
            title: CouponCodeScreen.title,
            iconData: Icons.local_activity_rounded,
            routename: CouponCodeScreen.routeName,
            press: onPress,
            index: 4,
          ),
          DrawerListTile(
            title: ReportScreen.title,
            iconData: Icons.local_activity_rounded,
            routename: ReportScreen.routeName,
            press: onPress,
            index: 5,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.routename,
    required this.iconData,
    required this.press,
    required this.index,
  }) : super(key: key);

  final String title, routename;
  final IconData iconData;
  final int index;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        press(context, title, routename, index);
      },
      horizontalTitleGap: 0.0,
      leading: Icon(
        iconData,
        color: Colors.white54,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
