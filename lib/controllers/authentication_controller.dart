import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/shared_pref_manager.dart';

class AuthenticationController {
  static AuthenticationController? _instance;

  factory AuthenticationController() {
    if(_instance == null) {
      _instance = AuthenticationController._();
    }
    return _instance!;
  }

  AuthenticationController._();

  Future<bool> isUserLogin({bool initializeUserid = false, BuildContext? context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    MyPrint.printOnConsole("User:${user}");

    bool isLogin = user != null;
    if(isLogin && initializeUserid && context != null) {
      CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);
      companyUserProvider.userUid = user.uid;
      companyUserProvider.firebaseUser = user;
      await SharedPrefManager().setString("userUid", companyUserProvider.userUid!);
      //await SembastManager().set(SEMBAST_USERID, companyUserProvider.userid!);
    }
    MyPrint.printOnConsole("Login:${isLogin}");
    return isLogin;
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }

      return userCredential.user!;
    }
    on FirebaseAuthException catch(e) {
      String message = "";

      MyPrint.printOnConsole("Code:${e.code}");
      switch(e.code) {
        case "invalid-email" : {
          message = "Entered Email is Invalid";
          MyPrint.printOnConsole("Message:${message}");
          MyToast.showError(message, context);
        }
        break;

        case "user-disabled" : {
          message = "Entered Email is Disabled";
          MyPrint.printOnConsole("Message:${message}");
          MyToast.showError(message, context);
        }
        break;

        case "user-not-found" : {
          message = "Entered Email doesn't exist";
          MyPrint.printOnConsole("Message:${message}");
          MyToast.showError(message, context);
        }
        break;

        case "wrong-password" : {
          message = "Entered Password is wrong";
          MyPrint.printOnConsole("Message:${message}");
          MyToast.showError(message, context);
        }
        break;

        default : {
          message = "Error in Authentication";
          MyPrint.printOnConsole("Message:${message}");
          MyToast.showError(message, context);
        }
      }
    }

    return null;
  }

  Future<bool> logout(BuildContext context) async {
    CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);
    companyUserProvider.firebaseUser = null;
    companyUserProvider.companyUserModel = null;
    companyUserProvider.userid = null;
    companyUserProvider.userUid = null;
    /*await SembastManager().set(SEMBAST_USERDATA, null);
    await SembastManager().set(SEMBAST_USERID, null);*/

    await FirebaseAuth.instance.signOut();
    return true;
  }
}