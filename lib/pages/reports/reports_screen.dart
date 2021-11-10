import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/controllers/data_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/controllers/report_controller.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

class ReportScreen extends StatefulWidget {
  static const String title = "Report";
  static const String routeName = "/ReportScreen";
  
  const ReportScreen({Key? key}) : super(key: key);
   
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<String> reportType = ['Users', 'Venues'];
  String selectedReport ='Users';
  List<dynamic> cities = [];
  String selectedCity ='';
  TextEditingController searchController = TextEditingController();
  FocusNode seachNode = FocusNode(canRequestFocus: true,);
  Map<String, dynamic>? placesMap;
  Map<String, dynamic> stateMap=HashMap();
  late ReportController reportController;
  

  Future getCityData() async {
  
   await DataController().getPlaces().then((Map<String, dynamic>? map) {
      placesMap = map; 
      
      for(var entry in placesMap!.entries){
       // print(placesMap![entry.key]);
        stateMap.addAll(placesMap![entry.key]);
      }
      for(var key in stateMap.keys)
      {
       // print(stateMap[key]);
        cities.addAll(stateMap[key]);
      }
      setState(() {
        selectedCity=cities.first;
       // print(cities);
      });
    
    });
    
  }


  @override
  void initState() {
    super.initState();
    reportController=ReportController();
    getCityData();
     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     // searchForUsers(Provider.of<CompanyUserProvider>(context, listen: false));
      reportController.getReportsList(selectedReport,context);
    });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainBody()
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? MySize.size50! : (Responsive.isTablet(context) ? MySize.size20! : MySize.size10!)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MySize.size8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getReportTypeList(),
                getCityList(),
                Expanded(child: getSearchTextField())
              ],
            ),
          ],
        ),
      ),
    );
  }
    

  Widget getReportTypeList () {
     return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Row(
        children: [
          Text("Report Type  :  ", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
          DropdownButton<String>(
            value: selectedReport,
            onChanged: (newValue) {
                  setState(() {
                    selectedReport = newValue!;
                    print("selectedreport"+selectedReport);
                  });
                },
            items: reportType.map((type) {
              return DropdownMenuItem(
                child: new Text(type),
                value: type,
              );
            }).toList(),  
          ),
        ],
      )
    );
   
  }
  Widget getCityList () {
     return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: Row(
        children: [
          Text("City  :  ", style: TextStyle(color: Styles.white, fontWeight: FontWeight.bold, fontSize: MySize.size20!),),
          DropdownButton<dynamic>(
            value: selectedCity,
            onChanged: (newValue) {
                  setState(() {
                    selectedCity = newValue!;
                    print("selectedcity"+selectedCity);
                  });
                },
            items: cities.map((value) {
              return DropdownMenuItem(
                child: new Text(value),
                value: value,
              );
            }).toList(),  
          ),
        ],
      )
    );
   
  }
  Widget getSearchTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
      child: TextFormField(
        focusNode: seachNode,
        controller: searchController,
        onChanged: (val) {
          setState(() {});
        },
        onEditingComplete: () {
        //  searchForUsers(companyUserProvider);
          seachNode.unfocus();
        },
        style: TextStyle(
          letterSpacing: 0,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size16!),),
            borderSide: BorderSide(color: Styles.white, width: 1,),
          ),
          /*enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size16!),),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size16!),),
            borderSide: BorderSide.none,
          ),*/
          filled: true,
          fillColor: bgColor,
          prefixIcon: InkWell(
            onTap: () {
              if(seachNode.hasFocus) {
                MyPrint.printOnConsole("Has focus");
                seachNode.unfocus();
              }
              else {
                seachNode.requestFocus();
              }
            },
            child: Icon(MdiIcons.magnify, size: MySize.size22, color: primaryColor,),
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? InkWell(
            child: Icon(Icons.close, size: MySize.size22, color: primaryColor,),
            onTap: () {
              setState(() {
                searchController.text = "";
              //  searchForUsers(companyUserProvider);
              });
            },
          )
              : SizedBox.shrink(),
          isDense: true,
          contentPadding: EdgeInsets.only(right: MySize.size16!),
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
