import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/controllers/authentication_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/controllers/providers/menu_provider.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/pages/authentication/login_screen.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<MenuProvider>().controlMenu,
            ),
          if (!Responsive.isMobile(context))
            Text(
              "${Provider.of<NavigationProvider>(context).selectedPageTitle}",
              style: Theme.of(context).textTheme.headline6,
            ),
          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 3 : 1)
          else Spacer(),
          /*Expanded(child: SearchField()),*/
          ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  void _showPopupMenu(BuildContext context, Offset offset) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: const Text('Logout'),
          value: 'Logout',
          onTap: () async {
            await AuthenticationController().logout(context);
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyUserProvider>(
      builder: (BuildContext context, CompanyUserProvider companyUserProvider, Widget? child) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            _showPopupMenu(context, details.globalPosition);
          },
          child: Container(
            margin: EdgeInsets.only(left: defaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/profile_pic.png",
                  height: 38,
                ),
                if (!Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    child: Text("${companyUserProvider.companyUserModel!.name ?? "Angelina Jolie"}"),
                  ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
