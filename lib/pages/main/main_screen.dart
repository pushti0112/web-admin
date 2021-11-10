import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/controllers/providers/menu_provider.dart';
import 'package:sportiwe_admin/pages/dashboard/components/header.dart';
import 'package:sportiwe_admin/pages/home_screen/home_screen.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  static const String title = "Main Screen";
  static const String routeName = "/MainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? homeScreenWidget;

  PageController? _pageController;

  GlobalKey key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: context.read<MenuProvider>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Column(
                children: [
                  Header(),
                  Expanded(child: getHomeScreen(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getHomeScreen() {
    if (homeScreenWidget == null)
      homeScreenWidget = HomeScreen();
    return homeScreenWidget!;
  }
}
