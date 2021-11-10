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

class EditUserScreen extends StatefulWidget {
  static const String title = "Edit User";
  static const String routeName = "/EditUserScreen";

  const EditUserScreen({Key? key}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  bool isLoading = false, isFirst = true;

  Future? getDataFuture;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController? nameController, mobileController;

  CompanyUserModel? companyUserModel;

  Map<String, String>? rolesMap, selectedMap;
  Map<String, dynamic>? placesMap;

  String? selectedState, selectedCity,selectedCountry;

  Map<dynamic,dynamic>? selectedStateMap;


  Future getData() async {
    MyPrint.printOnConsole("Getdata Called");

    NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    dynamic argument = ModalRoute.of(context)!.settings.arguments;
    if(argument != null) {
      MyPrint.printOnConsole("Argument is Not Null");

      if(argument.runtimeType.toString() == 'CompanyUserModel') {
        MyPrint.printOnConsole("Argument is CompanyUserModel");

        companyUserModel = argument as CompanyUserModel;
        MyPrint.printOnConsole("Argument:${companyUserModel}");

        int counter = 0;

        DataController().getRolesList(context).then((Map<String, String>? value) {
          rolesMap = value;
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

        while(counter < 2) {
          await Future.delayed(Duration(milliseconds: 100));
        }

        nameController!.text = companyUserModel!.name!;
        mobileController!.text = companyUserModel!.mobile!.substring(3);
        selectedState = companyUserModel!.state!;
        selectedCity = companyUserModel!.city!;
        selectedMap = {companyUserModel!.role! : rolesMap![companyUserModel!.role!]!};
        selectedCountry = companyUserModel!.country!;
        selectedStateMap={ companyUserModel!.state! : [companyUserModel!.city!] };
        selectedCityList = [companyUserModel!.city!];
        setState(() {});
      }
      else {
        navigationProvider.selectedPageTitle = UsersListScreen.routeName;
        navigationProvider.notifyListeners();

        MyPrint.printOnConsole("Argument is not CompanyUserModel");
        Navigator.pop(context);
      }
    }
    else {
      navigationProvider.selectedPageTitle = UsersListScreen.routeName;
      navigationProvider.notifyListeners();

      MyPrint.printOnConsole("Argument is Null");
      Navigator.pop(context);
    }
  }

  void editUser() async {
    setState(() {
      isLoading = true;
    });

    companyUserModel!.name = nameController!.text;
    companyUserModel!.mobile = "+91" + mobileController!.text;
    companyUserModel!.role = selectedMap!.keys.first;
    companyUserModel!.state = selectedState;
    companyUserModel!.city = selectedCity;
    companyUserModel!.country = selectedCountry;


    bool isEdited = await CompanyUserController().editCompanyUser(context, companyUserModel!);
    MyPrint.printOnConsole("IsEdited:${isEdited}");

    setState(() {
      isLoading = false;
    });

    if(isEdited) {
      NavigationProvider navigationProvider = Provider.of(context, listen: false);
      navigationProvider.selectedPageTitle = UsersListScreen.title;
      navigationProvider.notifyListeners();
      Navigator.pop(NavigationController().homeNavigatorKey.currentContext!);
    }
  }

  @override
  void initState() {
    nameController = TextEditingController();
    mobileController = TextEditingController();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getDataFuture = getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? MySize.size50! : (Responsive.isTablet(context) ? MySize.size20! : MySize.size10!)),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              getNameTextField(),
              getMobileTextField(),
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
                  getEditUserButtonWidget(),
                ],
              )
            ],
          ),
        ),
      ),
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

   Widget getEditUserButtonWidget() {
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
            editUser();
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
        icon: Icon(Icons.edit),
        label: Text("Edit User"),
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
}
