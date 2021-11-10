import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/controllers/authentication_controller.dart';
import 'package:sportiwe_admin/controllers/company_user_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/pages/commons/widgets/modal_progress_hud.dart';
import 'package:sportiwe_admin/pages/main/main_screen.dart';
import 'package:sportiwe_admin/utils/my_print.dart';

class LoginScreen extends StatefulWidget {
  static const String title = "Login Screen";
  static const String routeName = "/LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeData? themeData;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  TextEditingController? emailController, passwordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if(isLoading) return;

    setState(() {
      isLoading = true;
    });

    User? user = await AuthenticationController().signInWithEmailAndPassword(context, email: emailController!.text, password: passwordController!.text);
    MyPrint.printOnConsole("USer:${user}");

    setState(() {
      isLoading = false;
    });

    if(user != null) {
      onSuccess(user);
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSuccess(User user) async {
    print("Login Success");

    CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);
    companyUserProvider.userUid = user.uid;
    companyUserProvider.firebaseUser = user;

    bool isExist = await CompanyUserController().isUserExist(context, companyUserProvider.userUid!);

    if(isExist) {
      if(companyUserProvider.companyUserModel!.role == USER_ADMIN) {
        setState(() {
          isLoading = false;
        });

        Navigator.pushNamed(context, MainScreen.routeName);
      }
      else {
        MyToast.showError("Logged In User is Not Allowed To Login into Admin Panel", context);
        await AuthenticationController().logout(context);

        setState(() {
          isLoading = false;
        });
      }
    }
    else {
      MyToast.showError("Logged In User Data Not Exist", context);
      await AuthenticationController().logout(context);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    print("LoginScreen called");

    themeData = Theme.of(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.white,
      progressIndicator: SpinKitFadingCircle(color: primaryColor,),
      child: Scaffold(
        body: Center(
          child: Container(
            width: MySize.getScaledSizeHeight(500),
            padding: EdgeInsets.only(top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //getLogo(),
                          getLoginText(),
                          getLoginText2(),
                          SizedBox(height: MySize.size20,),
                          getEmailTextField(),
                          SizedBox(height: MySize.size10,),
                          getPasswordTextField(),
                          getContinueButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getLogo() {
    return Container(
      width: 300,
      height: 200,
      child: Image.asset("assets/vulcal logo (1).png"),
    );
  }

  Widget getLoginText() {
    return InkWell(
      onTap: ()async{

      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Center(
          child: Text(
            "Log In",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget getLoginText2() {
    return Container(
      margin: EdgeInsets.only(left: 48, right: 48, top: 40),
      child: Text(
        "Enter your login details to access your account",
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.2,
            color: themeData!.colorScheme.onBackground.withAlpha(200)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getEmailTextField() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: MySize.size4!, horizontal: MySize.size16!),
        decoration: BoxDecoration(
          color: Styles.white,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size10!),),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              color: Styles.blue,
              size: MySize.size26,
            ),
            SizedBox(
              width: MySize.size16!,
            ),
            Expanded(
              child: TextFormField(
                controller: emailController,
                cursorColor: Styles.blue,
                validator: (String? value) {
                  if(value!.isNotEmpty) {
                    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return null;
                    }
                    else {
                      return "Invalid Email";
                    }
                  }
                  else return "Email Address Cannot be empty";
                },
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Styles.blue,
                    fontSize: MySize.size20,
                    fontFamily: Styles.MONTSERRAT_MEDIUM,
                  ),
                ),
                style: TextStyle(
                  color: Styles.blue,
                  fontSize: MySize.size20,
                  fontFamily: Styles.MONTSERRAT_MEDIUM,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getPasswordTextField() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: MySize.size4!, horizontal: MySize.size16!),
        decoration: BoxDecoration(
          color: Styles.white,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size10!)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lock_outline,
              color: Styles.blue,
              size: MySize.size26,
            ),
            SizedBox(
              width: MySize.size16!,
            ),
            Expanded(
              child: TextFormField(
                controller: passwordController,
                cursorColor: Styles.blue,
                validator: (String? value) {
                  if(value!.isNotEmpty) {
                    if(value.length >= 6) return null;
                    else return "Minimum length is 6";
                  }
                  else return "Password Cannot be empty";
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Styles.blue,
                    fontSize: MySize.size20,
                    fontFamily: Styles.MONTSERRAT_MEDIUM,
                  ),
                ),
                style: TextStyle(
                  color: Styles.blue,
                  fontSize: MySize.size20,
                  fontFamily: Styles.MONTSERRAT_MEDIUM,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getContinueButton() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 36),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(48)),
        boxShadow: [
          BoxShadow(
            color:
            themeData!.colorScheme.primary.withAlpha(100),
            blurRadius: 5,
            offset: Offset(
                0, 5), // changes position of shadow
          ),
        ],
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: themeData!.colorScheme.primary,
        highlightColor: themeData!.colorScheme.primary,
        splashColor: Colors.white.withAlpha(100),
        padding: EdgeInsets.only(top: 16, bottom: 16),
        onPressed: login,
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "CONTINUE",
                style: TextStyle(
                    color: themeData!.colorScheme.onPrimary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              right: 16,
              child: ClipOval(
                child: Container(
                  color: themeData!.colorScheme.primaryVariant,
                  // button color
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.arrow_right_alt,
                        color: themeData!.colorScheme.onPrimary,
                        size: 18,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
