import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/controllers/company_user_controller.dart';
import 'package:sportiwe_admin/controllers/data_controller.dart';
import 'package:sportiwe_admin/controllers/navigation_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/controllers/providers/data_provider.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/controllers/providers/venue_provider.dart';
import 'package:sportiwe_admin/controllers/venue_controller.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';
import 'package:sportiwe_admin/models/venue_model.dart';
import 'package:sportiwe_admin/pages/edit_user_screen/edit_user_screen.dart';
import 'package:sportiwe_admin/pages/venues_list_screen/components/venue_list_widget.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/responsive.dart';

class VenuesListScreen extends StatefulWidget {
  static const String title = "Venues List";
  static const String routeName = "/VenuesListScreen";

  const VenuesListScreen({Key? key}) : super(key: key);

  @override
  _VenuesListScreenState createState() => _VenuesListScreenState();
}

class _VenuesListScreenState extends State<VenuesListScreen> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  ScrollController listScrollController = new ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode seachNode = FocusNode(canRequestFocus: true,);

  bool isShowResultsForText = false;
  String resultsForString = "";

  void searchForUsers(VenueProvider venueProvider)async {
    VenueController().resetFilterData(context);
    venueProvider.searchedVenue = searchController.text;
print("inVenue list calling");
    await  VenueController().getVenues(context, true);
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      searchForUsers(Provider.of<VenueProvider>(context, listen: false));
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<VenueProvider>(
      builder: (BuildContext context, VenueProvider venueProvider, Widget? child) {
        //MyPrint.printOnConsole("Products Length in ProductsListScreen build:" + productProvider.searchedProductsList.length.toString());
        //MyPrint.printOnConsole("Search Text:${productProvider.searchString}");
        isShowResultsForText = venueProvider.searchedVenue.isNotEmpty;
        resultsForString = venueProvider.searchedVenue;

        return getBody(venueProvider);
      },
    );
  }

  Widget getBody(VenueProvider venueProvider) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: _EndDrawer(
          scaffoldKey: _scaffoldKey,
          controller: searchController,
        ),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              getTopBar(venueProvider),
              isShowResultsForText ? Align(alignment: Alignment.centerLeft, child: getResultsForText(resultsForString)) : SizedBox.shrink(),
              Expanded(
                child: venueProvider.isFirstTimeLoading
                    ? Center(child: SpinKitFadingCircle(color: primaryColor,),)
                    : venueProvider.searchedVenuesList != null && venueProvider.searchedVenuesList!.isNotEmpty ? getUsersListView(venueProvider) : Center(child: Text("No Venues"),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Main UI Components
  Widget getTopBar(VenueProvider venueProvider) {
    return Padding(
      padding: EdgeInsets.all(MySize.size16!),
      child: Row(
        children: <Widget>[
          Expanded(
            child: getSearchTextField(venueProvider),
          ),
          getSortButton(),
          getFilterButton(),
        ],
      ),
    );
  }

  Widget getResultsForText(String text) {
    return Container(
      padding: EdgeInsets.only(left: MySize.size16!, top: 0),
      child: Text(
        "Result for \"$text\"",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Styles.white,
        ),
      ),
    );
  }

  Widget getUsersListView(VenueProvider venueProvider) {
    return Container(
      child: Stack(
        children: [
          AnimationLimiter(

            child: ListView.builder(
              controller: listScrollController,
              // padding: EdgeInsets.symmetric(vertical: MySize.size8!, horizontal: MySize.size8!).copyWith(bottom: venueProvider.isUsersLoading ? MySize.size100 : MySize.size40),
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount:
               venueProvider.searchedVenuesList != null ? venueProvider.searchedVenuesList!.length : 0,
              itemBuilder: (context, index) {
          
                //MyPrint.printOnConsole("$index generated");
          
                if(index == venueProvider.searchedVenuesList!.length - 3) {
                  Future.delayed(Duration(microseconds: 1), () {
                    VenueController().getVenues(context, false);
                  });
                }
          
                VenueModel model = venueProvider.searchedVenuesList![index];
          
                return AnimationConfiguration.staggeredList(
                  position: index,delay: Duration(milliseconds: 100),
                  child: SlideAnimation(
                duration:Duration(seconds: 1),

                    child: FadeInAnimation(
                      duration: Duration(seconds: 1),
                      child:
                      // _dataTable(venueProvider.searchedVenuesList!)
                       _VenueListWidget(
                        index: index + 1,
                        venueModel: model,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: 
            venueProvider.isVenuesLoading
                ?
                 Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 30),
              child: Center(
                child: SpinKitThreeBounce(
                  color: primaryColor,
                ),
              ),
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
  
  //  Widget getUsersListView(VenueProvider venueProvider) {
  //   return Container(
  //     child: Stack(
  //       children: [
  //         DataTable2(
  //           columns: [
  //             DataColumn(
  //                 label: Text("Image"),
  //               ),
  //             //  DataColumn(
  //             //     label: Text("Id"),
  //             //   ),
  //               DataColumn(
  //                 label: Text("Name"),
  //               ),
  //                DataColumn(
  //                 label: Text("Owner's Name"),
  //               ),
  //               DataColumn(
  //                 label: Text("Enabled By Owner"),
  //               ),
  //               DataColumn(
  //                 label: Text("Enabled By Venue"),
  //               ),
  //               // DataColumn(
  //               //   label: Text("Size"),
  //               // ),
  //           ],
  //           rows: List.generate(venueProvider.searchedVenuesList != null ? venueProvider.searchedVenuesList!.length : 0
  //           , (index) {
  //             return DataRow(cells: [
  //               DataCell(Image.network("${venueProvider.searchedVenuesList![index].imageList![0]}",height: 50,width:50)),
  //               // DataCell(Text("$index"),),
  //               DataCell(Text("${venueProvider.searchedVenuesList![index].name}"),)
  //               ,DataCell(Text("${venueProvider.searchedVenuesList![index].ownerName}"),)
  //               ,DataCell(getEnabledSelection(venueProvider.searchedVenuesList![index].isEnabledByOwner!,venueProvider.searchedVenuesList![index]),)
  //               ,DataCell(getEnabledSelection(venueProvider.searchedVenuesList![index].isEnabledByVenue!,venueProvider.searchedVenuesList![index]),)
  //             ]);

  //           })
            
  //           //  AnimationLimiter(
  //           //   child: ListView.builder(
  //           //     controller: listScrollController,
  //           //     // padding: EdgeInsets.symmetric(vertical: MySize.size8!, horizontal: MySize.size8!).copyWith(bottom: venueProvider.isUsersLoading ? MySize.size100 : MySize.size40),
  //           //     shrinkWrap: true,
  //           //     physics: AlwaysScrollableScrollPhysics(),
  //           //     itemCount:
  //           //      venueProvider.searchedVenuesList != null ? venueProvider.searchedVenuesList!.length : 0,
  //           //     itemBuilder: (context, index) {
            
  //           //       //MyPrint.printOnConsole("$index generated");
            
  //           //       if(index == venueProvider.searchedVenuesList!.length - 3) {
  //           //         Future.delayed(Duration(microseconds: 1), () {
  //           //           VenueController().getVenues(context, false);
  //           //         });
  //           //       }
            
  //           //       VenueModel model = venueProvider.searchedVenuesList![index];
            
  //           //       return AnimationConfiguration.staggeredList(
  //           //         position: index,delay: Duration(milliseconds: 100),
  //           //         child: SlideAnimation(
  //           //       duration:Duration(seconds: 1),
          
  //           //           child: FadeInAnimation(
  //           //             duration: Duration(seconds: 1),
  //           //             child:
  //           //             _dataTable(venueProvider.searchedVenuesList!)
  //           //             //  _VenueListWidget(
  //           //             //   index: index + 1,
  //           //             //   venueModel: model,
  //           //             // ),
  //           //           ),
  //           //         ),
  //           //       );
  //           //     },
  //           //   ),
  //           // ),
  //         ),
  //         Align(
  //           alignment: Alignment.bottomCenter,
  //           child: 
  //           venueProvider.isVenuesLoading
  //               ?
  //                Container(
  //             height: 40,
  //             margin: EdgeInsets.only(bottom: 30),
  //             child: Center(
  //               child: SpinKitThreeBounce(
  //                 color: primaryColor,
  //               ),
  //             ),
  //           )
  //               : SizedBox.shrink(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  
   Widget getSectionTitleText(String title) {
    return Container(
      padding: EdgeInsets.only(
          top: MySize.size16!),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
      ),
    );
  }
  //  Widget getEnabledSelection(bool enabled , VenueModel venueModel) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 0),
  //     decoration: BoxDecoration(
  //         color: bgColor,
  //         borderRadius: BorderRadius.circular(10)
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         getSectionTitleText("Enabled"),
  //         SizedBox(width: MySize.size10,),
  //         Switch(
  //           activeColor: primaryColor,
  //           inactiveThumbColor: Colors.grey,
  //           value: enabled,
  //           onChanged: (val) async {
  //             setState(() {
  //              venueModel.isEnabledByOwner = val;
  //             });

  //             bool isUpdated = await VenueController().enableVenue(venueModel.id!, venueModel.isEnabledByOwner!);

  //             if(!isUpdated) {
  //               setState(() {
  //                 venueModel.isEnabledByOwner = !val;
  //               });
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

 
  
//     _dataTable(List<VenueModel> venueModel){
//   return SizedBox(
//             width: double.infinity,
//             child: DataTable2(
//               columnSpacing: defaultPadding,
//               minWidth: 600,
//               columns: [
//                 DataColumn(
//                   label: Text("File Name"),
//                 ),
//                 DataColumn(
//                   label: Text("Date"),
//                 ),
//                 DataColumn(
//                   label: Text("Size"),
//                 ),
//               ],
//               rows: List.generate(
//                 venueModel.length,
//                 (index) => recentFileDataRow(venueModel[index]),
//               ),
//             ),
//           );
// }

DataRow recentFileDataRow(VenueModel venueModel) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Icon(Icons.ac_unit_outlined),
            // SvgPicture.asset(
            //   fileInfo.icon!,
            //   height: 30,
            //   width: 30,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(venueModel.name!),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(venueModel.address!),),
      DataCell(Text("${venueModel.rating}"),),
    ],
  );
}



  //Supporting UI Components
  Widget getSearchTextField(VenueProvider venueProvider) {
    return TextFormField(
      focusNode: seachNode,
      controller: searchController,
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        searchForUsers(venueProvider);
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
              searchForUsers(venueProvider);
            });
          },
        )
            : SizedBox.shrink(),
        isDense: true,
        contentPadding: EdgeInsets.only(right: MySize.size16!),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget getSortButton() {
    return getTopBarButton(
        MdiIcons.swapVertical,
            () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext buildContext) {
              return SortBottomSheet();
            },
          );
        }
    );
  }

  Widget getFilterButton() {
    return getTopBarButton(
      MdiIcons.tune,
          () {
        _scaffoldKey.currentState!.openEndDrawer();
      },
    );
  }

  Widget getTopBarButton(IconData icondata, Function onPressed) {
    return InkWell(
      onTap: () {
        if(onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: MySize.size16!),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size16!)),
          boxShadow: [
            BoxShadow(
              color: Styles.white.withAlpha(48),
              blurRadius: 3,
              offset: Offset(0, 1),
            )
          ],
        ),
        padding: EdgeInsets.all(MySize.size12!),
        child: Icon(
          icondata,
          color: primaryColor,
          size: 22,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  int _radioValue = 0;
  VenueProvider? venueProvider;
  bool isFirst = true;

  void setSortValue(int value) {
    if(_radioValue != value) {
      setState(() {
        _radioValue = value;
        venueProvider!.sortValue = value;
        venueProvider!.notifyListeners();
      });

      VenueController().getVenues(context, true);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if(isFirst) {
      isFirst = false;
      venueProvider = Provider.of<VenueProvider>(context, listen: false);
      _radioValue = venueProvider!.sortValue;
    }

    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: themeData.backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16!),
                topRight: Radius.circular(MySize.size16!))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: MySize.size16!, horizontal: MySize.size24!,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: MySize.size8!),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setSortValue(0);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (value) {
                              setSortValue(0);
                            },
                            groupValue: _radioValue,
                            value: 0,
                            visualDensity: VisualDensity.compact,
                            activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Last Updated - ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Descending",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setSortValue(1);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (value) {
                              setSortValue(1);
                            },
                            groupValue: _radioValue,
                            value: 1,
                            visualDensity: VisualDensity.compact,
                            activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Last Updated - ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text("Ascending",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setSortValue(2);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (value) {
                              setSortValue(2);
                            },
                            groupValue: _radioValue,
                            value: 2,
                            visualDensity: VisualDensity.compact,
                            activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Name - ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "A to Z",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setSortValue(3);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (value) {
                              setSortValue(3);
                            },
                            groupValue: _radioValue,
                            value: 3,
                            visualDensity: VisualDensity.compact,
                            activeColor: themeData.colorScheme.primary,
                          ),
                          Text(
                            "Name - ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Z to A",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 
}

class _VenueListWidget extends StatefulWidget {
  VenueModel venueModel;
  int index;

  _VenueListWidget({
    Key? key,
    required this.index,
    required this.venueModel,
  })
      : super(key: key);

  @override
  __VenueListWidgettState createState() => __VenueListWidgettState();
}

class __VenueListWidgettState extends State<_VenueListWidget> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {

    DataProvider dataProvider = Provider.of<DataProvider>(context);

    //MyPrint.printOnConsole("Width:" + MediaQuery.of(context).size.width.toString());
    //MyPrint.printOnConsole("IsFavourite:" + widget.product.isfavourite.toString());
    return InkWell(
      onTap: () async {

      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MySize.size10!),
        padding: EdgeInsets.symmetric(vertical: MySize.size10!, horizontal: MySize.size16!),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size16!)),
          boxShadow: [
            BoxShadow(
              color: Styles.white.withAlpha(16),
              blurRadius: MySize.size8!,
              spreadRadius: MySize.size4!,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: MySize.size50!,
              //color: Colors.red,
              child: Text("${widget.index}.", textAlign: TextAlign.end,),
            ),
            SizedBox(width: MySize.size20!,),
            Expanded(
              child:
              Responsive.isMobile(context)?
              VenueListWidget(venueModel: widget.venueModel):_venueListwidgetDessktop()
            ),
          ],
        ),
      ),
    );
  }

   _venueListwidgetDessktop(){
      return Row(
              children: [
                imageView("${widget.venueModel.imageList![0]}"),
                SizedBox(width: MySize.size20!,),
                Expanded(flex: 3,
                   child: Container(
                     child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     mainAxisSize: MainAxisSize.max,
                     children: [
                      //  SelectableText(data)
                        SelectableText("${widget.venueModel.id}",style: TextStyle(decorationStyle: TextDecorationStyle.solid,color: Colors.white,decoration:TextDecoration.underline),),
                         SizedBox(width: MySize.size10!,),
                        Text("${widget.venueModel.name}"),
                         SizedBox(width: MySize.size10!,),
                        Text("${widget.venueModel.address}"),
                        Text("${widget.venueModel.phone}"),
                      ],
                  ),
                   ),
                ),
                Row(
                  children: [
                     getEnabledSelection(widget.venueModel.isEnabledByOwner!,"Admin" ,true),
                     getEnabledSelection(widget.venueModel.isEnabledByVenue!,"Venue",false)
                  ],
                )
                  // SizedBox(width: MySize.size20!,),
                  // Expanded(flex: 1, child: Text("${widget.venueModel.}")),
                  // SizedBox(width: MySize.size20!,),
                  // Expanded(flex: 1, child: Text("${widget.venueModel.password}")),
                  // SizedBox(width: MySize.size20!,),
                  // Expanded(flex: 1, child: Text("${widget.venueModel.mobile}")),
                  // SizedBox(width: MySize.size20!,),
                  // Expanded(flex: 1, child: Text("${widget.venueModel.id}")),
                  // SizedBox(width: MySize.size20!,),
                  // Expanded(flex: 1, child: Text("${dataProvider.rolesMap != null && dataProvider.rolesMap!.isNotEmpty ? dataProvider.rolesMap![widget.venueModel.role] : ""}")),
                  // SizedBox(width: MySize.size20!,),
                  // Expanded(flex: 1, child: getEnabledSelection(widget.venueModel.enabled!)),
                  // SizedBox(width: MySize.size20!,),
                  // getEditButton(widget.venueModel),
                ],
              );
    }

    Widget imageView(url){
      return Container(
          height:80,
          width:80,
        child: Image.network(
          "$url",
        
          fit:BoxFit.cover,
          errorBuilder: (context, Object exception, StackTrace? stackTrace) => Icon(Icons.image,size:100,color:Colors.grey) )
      );
    }
  
 

  Widget getSectionTitleText(String title) {
    return Container(
      padding: EdgeInsets.only(
          top: MySize.size16!),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
      ),
    );
  }

  Widget getEnabledSelection(bool enabled,String text,bool isCompanyUser) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getSectionTitleText("$text"),
          // SizedBox(height: MySize.size10,),
          Switch(
            activeColor: primaryColor,
            inactiveThumbColor: Colors.grey,
            value: enabled,
            onChanged: (val) async {
              if(isCompanyUser){
                  setState(() {
                widget.venueModel.isEnabledByOwner = val;
              });

              bool isUpdated = await VenueController().enableVenue(widget.venueModel.id!, widget.venueModel.isEnabledByOwner!,"isEnabledByOwner");

              if(!isUpdated) {
                setState(() {
                  widget.venueModel.isEnabledByOwner = !val;
                });
              }
            } else {
                  setState(() {
                widget.venueModel.isEnabledByVenue = val;
              });

              bool isUpdated = await VenueController().enableVenue(widget.venueModel.id!, widget.venueModel.isEnabledByVenue!,"isEnabledByVenue");

              if(!isUpdated) {
                setState(() {
                  widget.venueModel.isEnabledByVenue = !val;
                });
              }
              }

              // setState(() {
              //   widget.venueModel.enabled = val;
              // });

              // bool isUpdated = await VenueController().enableCompanyUser(widget.venueModel.id!, widget.venueModel.enabled!);

              // if(!isUpdated) {
              //   setState(() {
              //     widget.venueModel.enabled = !val;
              //   });
              // }
            },
          ),
        ],
      ),
    );
  }

  Widget getEditButton(CompanyUserModel companyUserModel) {
    return InkWell(
      onTap: () async {
        NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
        navigationProvider.selectedPageTitle = EditUserScreen.title;
        navigationProvider.notifyListeners();

        await Navigator.pushNamed(NavigationController().homeNavigatorKey.currentContext!, EditUserScreen.routeName, arguments: companyUserModel);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(MySize.size8!),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(MySize.size20!),
        ),
        child: Icon(Icons.edit, color: Colors.white,),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _EndDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  TextEditingController controller;

  _EndDrawer({Key? key, required this.scaffoldKey, required this.controller}) : super(key: key);

  @override
  __EndDrawerState createState() => __EndDrawerState();
}

class __EndDrawerState extends State<_EndDrawer> {
  //For Category and SubCategory Selection
  String selectedRole = "", selectedState = '', selectedCity = "";
  Map<String, dynamic>? rolesList = {}, stateList = {};
  List<String>? cityList = [];
  bool enabled = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initializeValuesFromCompanyUserProvider(context);
    });
  }

  void initializeValuesFromCompanyUserProvider(BuildContext context) async {
    MyPrint.printOnConsole("Called");
    rolesList = await DataController().getRolesList(context) ?? {};
    stateList = await DataController().getPlaces() ?? {};

    VenueProvider venueProvider = Provider.of<VenueProvider>(context, listen: false);

    MyPrint.printOnConsole("Selected State:" + venueProvider.selectedState);
    setState(() {
      // selectedRole = venueProvider.selectedRole;
      selectedState = venueProvider.selectedState;
      enabled = venueProvider.enabled;

      if(selectedState.isEmpty) {
        cityList = [];
      }
      else {
        if(stateList!.isNotEmpty) {
          cityList = List.castFrom(stateList![selectedState] ?? []);
        }
        else cityList = [];
      }

      selectedCity = venueProvider.selectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.25 : (Responsive.isTablet(context) ? 0.35 : 0.75)),
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTitleBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  rolesList!.isNotEmpty ? getSectionTitleText("Role") : SizedBox.shrink(),
                  Container(
                    padding: EdgeInsets.only(left: MySize.size16!, right: MySize.size16!, top: MySize.size16!),
                    child: getRoleSelection(),
                  ),
                  stateList!.isNotEmpty ? getSectionTitleText("State") : SizedBox.shrink(),
                  Container(
                    padding: EdgeInsets.only(left: MySize.size16!, right: MySize.size16!, top: MySize.size16!),
                    child: getStateSelection(),
                  ),
                  cityList!.isNotEmpty ? getSectionTitleText("City") : SizedBox.shrink(),
                  Container(
                    padding: EdgeInsets.only(left: MySize.size16!, right: MySize.size16!, top: MySize.size16!),
                    child: getCitySelection(),
                  ),
                  enabled != null ? getSectionTitleText("Enabled") : SizedBox.shrink(),
                  Container(
                    padding: EdgeInsets.only(left: MySize.size16!, right: MySize.size16!, top: MySize.size16!),
                    child: getEnabledSelection(),
                  ),
                  getApplyButton(),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Main UI Components
  Widget getTitleBar() {
    return Container(
      padding: EdgeInsets.only(top: MySize.size12!, bottom: MySize.size12!, left: MySize.size6!, right: MySize.size12!, ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                "FILTER",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                VenueController().resetFilterData(context);
                MyPrint.printOnConsole("Cleared");
                VenueController().getVenues(context, true);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Text("Clear"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getStateSelection() {
    if(stateList == null || stateList!.isEmpty) return Container();

    List<Widget> chips = [];
    stateList!.keys.forEach((item) {
      chips.add(getStateChip(item));
    });

    return Wrap(
      children: chips,
    );
  }

  Widget getCitySelection() {
    if(cityList == null || cityList!.isEmpty) return Container();

    List<Widget> chips = [];
    cityList!.forEach((item) {
      chips.add(getCityChip(item));
    });

    return Wrap(
      children: chips,
    );
  }

  Widget getRoleSelection() {
    if(rolesList == null || rolesList!.isEmpty) return Container();

    return Wrap(
      runSpacing: 10,
      children: rolesList!.entries.map((e) {
        return getRoleChip(e.key, e.value);
      }).toList(),
    );
  }

  Widget getEnabledSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getSectionTitleText("Enabled"),
          SizedBox(width: 10,),
          Switch(
            activeColor: primaryColor,
            inactiveThumbColor: Colors.grey,
            value: enabled,
            onChanged: (val) {
              setState(() {
                enabled = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget getApplyButton() {
    return Container(
      margin: EdgeInsets.all(MySize.size24!),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(MySize.size4!)),
        boxShadow: [
          BoxShadow(
            color: Styles.white.withAlpha(24),
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: FlatButton(
        onPressed: () {
          VenueController().setFilterData(
            context,
            selectedState: selectedState,
            selectedCity: selectedCity,
            // selectedRole: selectedRole,
            // searchUser: widget.controller.text,
            enabled: enabled,
          );
          VenueController().getVenues(context, true);
          Navigator.pop(context);
        },
        child: Text(
          "APPLY",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Styles.white,
              letterSpacing: 0.3),
        ),
        padding: EdgeInsets.only(top: MySize.size12!, bottom: MySize.size12!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.size8!)),
        color: primaryColor,
        splashColor: Colors.white.withAlpha(40),
        highlightColor: primaryColor,
      ),
    );
  }




  //Supporting UI Components
  Widget getSectionTitleText(String title) {
    return Container(
      padding: EdgeInsets.only(
          left: MySize.size16!,
          right: MySize.size16!,
          top: MySize.size16!),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
      ),
    );
  }

  Widget getStateChip(String state) {
    DataProvider dataProvider = Provider.of(context, listen: false);

    return Container(
      margin: EdgeInsets.all(MySize.size6!),
      decoration: BoxDecoration(
        border: Border.all(color: selectedState == state ? Colors.transparent : Styles.white, width: 1),
        borderRadius: BorderRadius.circular(MySize.size50!),
      ),
      child: ChoiceChip(
        backgroundColor: bgColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: primaryColor,
        label: Text(
          state,
          style: TextStyle(
            color: selectedState == state
                ? Styles.white
                : primaryColor,
            fontWeight: selectedState == state ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: selectedState == state,
        onSelected: (selected) {
          setState(() {
            if(selectedState == state) {
              selectedState = "";
              cityList = [];
              selectedCity = "";
            }
            else {
              selectedState = state;
              cityList = List.castFrom(stateList![state] ?? []);
            }
          });
          //MyPrint.printOnConsole("Selected Category:" + selectedCategory);
        },
      ),
    );
  }

  Widget getCityChip(String city) {
    return Container(
      margin: EdgeInsets.all(MySize.size6!),
      decoration: BoxDecoration(
        border: Border.all(color: selectedCity == city ? Colors.transparent : Styles.white, width: 1),
        borderRadius: BorderRadius.circular(MySize.size50!),
      ),
      child: ChoiceChip(
        backgroundColor: bgColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: primaryColor,
        label: Text(
          city,
          style: TextStyle(
            color: selectedCity == city ? Styles.white : primaryColor,
            fontWeight: selectedCity == city ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: selectedCity == city,
        onSelected: (selected) {
          setState(() {
            if(selectedCity == city) {
              selectedCity = "";
            }
            else {
              selectedCity = city;
            }
          });
          //MyPrint.printOnConsole("Selected Category:" + selectedCategory);
        },
      ),
    );
  }

  Widget getRoleChip(String key, String value) {
    return Container(
      margin: EdgeInsets.all(MySize.size6!),
      decoration: BoxDecoration(
        border: Border.all(color: selectedRole == key ? Colors.transparent : Styles.white, width: 1),
        borderRadius: BorderRadius.circular(MySize.size50!),
      ),
      child: ChoiceChip(
        backgroundColor: bgColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: primaryColor,
        label: Text(
          value,
          style: TextStyle(
            color: selectedRole == key ? Styles.white : primaryColor,
            fontWeight: selectedRole == key ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: selectedRole == key,
        onSelected: (selected) {
          setState(() {
            if(selectedRole == key) {
              selectedRole = "";
            }
            else {
              selectedRole = key;
            }
          });
          //MyPrint.printOnConsole("Selected Category:" + selectedCategory);
        },
      ),
    );
  }



}


 