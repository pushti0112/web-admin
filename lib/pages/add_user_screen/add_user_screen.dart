import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/controllers/data_controller.dart';
import 'package:sportiwe_admin/controllers/navigation_controller.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/controllers/company_user_controller.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/pages/commons/widgets/modal_progress_hud.dart';
import 'package:sportiwe_admin/pages/users_list_screen/users_list_screen.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

class AddUserScreen extends StatefulWidget {
  static const String title = "Add User";
  static const String routeName = "/AddUserScreen";

  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> with AutomaticKeepAliveClientMixin {
  bool isLoading = false, isFirst = true;

  Future? getDataFuture;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController? nameController, mobileController, emailController, passwordController;

  Map<String, String>? rolesMap, selectedMap;
  Map<dynamic,dynamic>? selectedStateMap;
  Map<String, dynamic>? placesMap;

  String? selectedCountry,selectedState, selectedCity;

  int? userCounter;

  Future getData() async {
    int counter = 0;

    DataController().getRolesList(context).then((Map<String, String>? value) {
      rolesMap = value;
    })
    .whenComplete(() {
      counter++;
    });
    DataController().getUserCounter(context).then((int? value) {
      userCounter = value;
    })
    .whenComplete(() {
      counter++;
    });
    DataController().getPlaces().then((Map<String, dynamic>? map) {
      placesMap = map;
    })
    .whenComplete(() {
      counter++;
    });

    while(counter < 3) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void addUser() async {
    setState(() {
      isLoading = true;
    });

    CompanyUserModel companyUserModel = CompanyUserModel(
      id: "${SPORTIWE_USER_PREFIX}${userCounter}",
      name: nameController!.text,
      lowername: nameController!.text.toLowerCase(),
      mobile: "+91" + mobileController!.text,
      email: emailController!.text,
      password: passwordController!.text,
      users: [],
      role: selectedMap!.keys.first,
      enabled: true,
      state: selectedState,
      city: selectedCity,
    );

    bool isAdded = await CompanyUserController().createCompanyUser(context, companyUserModel);
    MyPrint.printOnConsole("IsAdded:${isAdded}");

    setState(() {
      isLoading = false;
    });

    if(isAdded) {
      NavigationProvider navigationProvider = Provider.of(context, listen: false);
      navigationProvider.selectedPageTitle = UsersListScreen.title;
      navigationProvider.notifyListeners();
      Navigator.popAndPushNamed(NavigationController().homeNavigatorKey.currentContext!, UsersListScreen.routeName);
    }
  }

  @override
  void initState() {
    nameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    getDataFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: SpinKitFadingCircle(color: primaryColor,),
          color: Colors.white60,
          child: Scaffold(
            body: FutureBuilder(
              future: getDataFuture!,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return getMainBody();
                }
                else {
                  return Center(child: SpinKitFadingCircle(color: primaryColor,),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getMainBody() {
    if(isFirst) {
      isFirst = false;

      if(selectedMap == null && rolesMap != null && rolesMap!.isNotEmpty) {
        MapEntry mapEntry = rolesMap!.entries.first;
        selectedMap = {mapEntry.key : mapEntry.value};
      }

      /*if(selectedState == null && placesMap != null && placesMap!.isNotEmpty) {
        MapEntry mapEntry = placesMap!.entries.first;
        selectedState = mapEntry.key;
      }*/
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? MySize.size50! : (Responsive.isTablet(context) ? MySize.size20! : MySize.size10!)),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  getUseridWidget(),
                ],
              ),

              getNameTextField(),
              getMobileTextField(),
              getEmailTextField(),
              getPasswordTextField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getRoleSelection(),
                  SizedBox(width: MySize.size30!,),
                  getCountrySelection(),
                  SizedBox(width: MySize.size30!,),
                  getStateSelection(),
                  SizedBox(width: MySize.size30!,),
                  getCitySelection(),
                ],
              ),
              SizedBox(height: MySize.size20!,),
              Column(
                children: [
                  getAddUserButtonWidget(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getUseridWidget() {
    if(userCounter == null) return Center(child: Text("No Userid"),);

    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Text("Userid : ${SPORTIWE_USER_PREFIX}${userCounter}"),
    );
  }

  Widget getNameTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: TextFormField(
        controller: nameController,
        validator: (val) {
          if(val!.isEmpty) {
            return "Name Cannot be empty";
          }
          else{
            return null;
          }
        },
        decoration: getTextFieldInputDecoration(hintText: "Name", fillColor: Colors.black),
      ),
    );
  }

  Widget getMobileTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: TextFormField(
        controller: mobileController,
        validator: (val) {
          if(val!.isEmpty) {
            return "Mobile Cannot be empty";
          }
          else{
            if(RegExp(r"^[0-9]{10}$").hasMatch(val)) {
              return null;
            }
            else return "Not a Valid Mobile";
          }
        },
        decoration: getTextFieldInputDecoration(hintText: "Mobile", fillColor: Colors.black),
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [
          FilteringTextInputFormatter.deny("."),
          //LengthLimitingTextInputFormatter(10),
        ],
      ),
    );
  }

  Widget getEmailTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: TextFormField(
        controller: emailController,
        validator: (val) {
          if(val!.isEmpty) {
            return "Email Cannot be empty";
          }
          else{
            if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
              return null;
            }
            else return "Not a Valid Email";
          }
        },
        decoration: getTextFieldInputDecoration(hintText: "Email", fillColor: Colors.black),
      ),
    );
  }

  Widget getPasswordTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: TextFormField(
        controller: passwordController,
        validator: (val) {
          if(val!.isEmpty) {
            return "Password Cannot be empty";
          }
          else{
            return null;
          }
        },
        decoration: getTextFieldInputDecoration(hintText: "Password", fillColor: Colors.black),
      ),
    );
  }

  Widget getRoleSelection() {
    if(rolesMap == null || rolesMap!.isEmpty) return Container(child: Center(child: Text("No Roles")),);

    //MyPrint.printOnConsole("RolesMap:${rolesMap}");
    //MyPrint.printOnConsole("Selected Map:${selectedMap}");

    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Row(
        children: [
          Text("Role  :  ", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
          DropdownButton<String?>(
            value: selectedMap!.keys.first,
            onChanged: (String? value) {
              setState(() {
                selectedMap = {value! : rolesMap![value]!};
              });
            },
            hint: Text("Role", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
            items: rolesMap!.entries.map((MapEntry mapEntry) {
              return DropdownMenuItem<String>(
                value: mapEntry.key,
                onTap: () {
                  selectedMap = {mapEntry.key : mapEntry.value};
                  setState(() {});
                },
                child: Text("${mapEntry.value}"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  Widget getCountrySelection(){
     if(placesMap == null || placesMap!.isEmpty) return Container(child: Center(child: Text("No Places")),);

    //MyPrint.printOnConsole("RolesMap:${rolesMap}");
    //MyPrint.printOnConsole("Selected Map:${selectedMap}");

    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Row(
        children: [
          Text("Country  :  ", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
          DropdownButton<String?>(
            value: selectedCountry,
            onChanged: (value) {
              setState(() {
                print(value);
                selectedCountry = value;
                // selectedStateMap = value;
              });
            },
            hint: Text("Country", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
            items: placesMap!.entries.map((MapEntry mapEntry) {
              return DropdownMenuItem<String>(
                value: mapEntry.key,
                onTap: () {
                  // selectedState = mapEntry.key;
                  selectedCountry = mapEntry.key;
                  selectedStateMap = mapEntry.value;
                  print(mapEntry);
                  setState((){});
                },
                child: Text("${mapEntry.key}"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  String? tempSelected;
  
  Widget getStateSelection() {
    if(selectedStateMap == null || selectedStateMap!.isEmpty) return Container(child: Center(child: Text("No Places")),);

    //MyPrint.printOnConsole("RolesMap:${rolesMap}");
    //MyPrint.printOnConsole("Selected Map:${selectedMap}");

    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Row(
        children: [
          Text("State  :  ", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
          DropdownButton<String?>(
            value: selectedState,
            onChanged: (String? value) {
              setState(() {
                selectedState = value;

              });
            },
            hint: Text("State", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
            items: selectedStateMap!.entries.map((MapEntry mapEntry) {
              return DropdownMenuItem<String>(
                value: mapEntry.key,
                onTap: () {
                  selectedCity = tempSelected;
                  selectedCityList = [];
                  selectedState = mapEntry.key;
                  selectedCityList = mapEntry.value;
                  print(mapEntry.value!.length);
                  

                  setState(() {});
                },
                child: Text("${mapEntry.key}"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  List<dynamic>? selectedCityList  = [];

  Widget getCitySelection() {
    if(selectedState == null || selectedState!.isEmpty) return Container(child: Center(child: Text("No State Selected")),);
    //MyPrint.printOnConsole("RoselectedCitylesMap:${rolesMap}");
    //MyPrint.printOnConsole("Selected Map:${selectedMap}");

    List<String> cityList = List.castFrom(selectedCityList!);
    if(selectedCity == null && cityList.isNotEmpty) selectedCity = cityList.first;

    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Row(
        children: [
          Text("City  :  ", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
          DropdownButton<String?>(
            value: selectedCity,
            onChanged: (String? value) {
              setState(() {
                selectedCity = value;
              });
            },
            hint: Text("City", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
            items: cityList.map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                onTap: () {
                  selectedCity = city;
                  setState(() {});
                },
                child: Text("${city}"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget getAddUserButtonWidget() {
    return Container(
      margin: EdgeInsets.only(top: MySize.size10!),
      padding: EdgeInsets.symmetric(horizontal: MySize.size16!),
      child: ElevatedButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding * 1.5,
            vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
          ),
        ),
        onPressed: () {
          if(_key.currentState!.validate() && (selectedMap != null && selectedMap!.isNotEmpty) && (selectedState != null && selectedState!.isNotEmpty) && (selectedCity != null && selectedCity!.isNotEmpty)) {
            MyPrint.printOnConsole("Valid");
            addUser();
          }
          else {
            if(selectedMap == null || selectedMap!.isEmpty) {
              MyPrint.printOnConsole("Selected Role Cannot Null");
              MyToast.showError("Selected Role Cannot Null", context);
            }
            else if(selectedState == null || selectedState!.isEmpty) {
              MyPrint.printOnConsole("Selected State Cannot Null");
              MyToast.showError("Selected State Cannot Null", context);
            }
            else if(selectedCity == null || selectedCity!.isEmpty) {
              MyPrint.printOnConsole("Selected City Cannot Null");
              MyToast.showError("Selected City Cannot Null", context);
            }
          }
        },
        icon: Icon(Icons.add),
        label: Text("Add User"),
      ),
    );
  }

  InputDecoration getTextFieldInputDecoration({required String hintText, required Color fillColor}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        letterSpacing: 0.1,
        color: Styles.grey,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: EdgeInsets.all(15),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
