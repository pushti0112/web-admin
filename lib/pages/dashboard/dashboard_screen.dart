import 'package:flutter/material.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/pages/dashboard/components/my_fields.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  static const String title = "Dashboard";
  static const String routeName = "/DashboardScreen";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StarageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
