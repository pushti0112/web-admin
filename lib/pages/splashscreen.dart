import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/controllers/app_controller.dart';
import 'package:sportiwe_admin/controllers/authentication_controller.dart';
import 'package:sportiwe_admin/controllers/company_user_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/pages/authentication/login_screen.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/pages/main/main_screen.dart';
import 'package:sportiwe_admin/utils/my_print.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "/SplashScreen";
  const SplashScreen({Key? key}) : super(key: key);

  void startListners(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));

    bool isLogin = await AuthenticationController().isUserLogin(context: context, initializeUserid: true);
    MyPrint.printOnConsole("IsLogin:${isLogin}");

    if(isLogin) {
      CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);
      bool isExist = await CompanyUserController().isUserExist(context, companyUserProvider.userUid!);

      if(isExist) {
        if(companyUserProvider.companyUserModel!.role == USER_ADMIN) {
          Navigator.popAndPushNamed(context, MainScreen.routeName);
        }
        else {
          MyToast.showError("Logged In User is Not Allowed To Login into Admin Panel", context);
          await AuthenticationController().logout(context);

          Navigator.popAndPushNamed(context, LoginScreen.routeName);
        }
      }
      else {
        MyToast.showError("Logged In User Data Not Exist", context);
        await AuthenticationController().logout(context);
        Navigator.popAndPushNamed(context, LoginScreen.routeName);
      }
    }
    else {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = AppController().isLightTheme!;

    MySize().init(context);
    startListners(context);

    return Container(
      color: isLight ? Styles.white : Styles.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isLight ? Styles.white : Styles.black,
          body: Container(
            child: Center(child: Image.asset("assets/logo/logo1.png", height: MySize.size180, width: MySize.size180,)),
          ),
        ),
      ),
    );
  }
}
