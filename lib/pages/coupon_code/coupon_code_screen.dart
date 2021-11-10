import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/controllers/coupon_code_controller.dart';
import 'package:sportiwe_admin/controllers/data_controller.dart';
import 'package:sportiwe_admin/controllers/navigation_controller.dart';
import 'package:sportiwe_admin/controllers/providers/coupon_code_provider.dart';
import 'package:sportiwe_admin/controllers/providers/navigation_provider.dart';
import 'package:sportiwe_admin/controllers/company_user_controller.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';
import 'package:sportiwe_admin/models/coupon_code_model.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/pages/commons/widgets/modal_progress_hud.dart';
import 'package:sportiwe_admin/pages/users_list_screen/users_list_screen.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/responsive.dart';
import 'package:uuid/uuid.dart';

class CouponCodeScreen extends StatefulWidget {
  static const String title = "Coupon Code";
  static const String routeName = "/CouponCodeScreen";

  const CouponCodeScreen({Key? key}) : super(key: key);

  @override
  _CouponCodeScreenState createState() => _CouponCodeScreenState();
}

class _CouponCodeScreenState extends State<CouponCodeScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false, isFirst = true;

  Future? getDataFuture;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController? prefixController,
      mobileController,
      emailController,
      passwordController,
      discountController,
      countController,
      maxAmountController,
      percentController,
      expireTimePickerController;

  String _groupValue = "One_Time";

  String _discountType = "discount_by_amount";

  List<CouponModel> couponList = [
    CouponModel(
      prefix: "Prefix",
    )
  ];

  bool noExpirationSelected = false;
  int loadingCount = 0;

  void addCoupon() async {
    setState(() {
      isLoading = true;
    });

    await CouponCodeController()
        .setCoupon(
      discountType: _discountType,
            maxDiscountAmount: double.tryParse(maxAmountController!.text) ?? 0.0,
            percentage: int.tryParse(percentController!.text) ?? 0,
            context: context,
            prefix: prefixController!.text.substring(0, 3),
            count: int.tryParse(countController!.text) ?? 0,
            amount: double.tryParse(discountController!.text) ?? 0.0,
            type: _groupValue,

            expiryData:
                noExpirationSelected ? null : Timestamp.fromDate(pickedTime!))
        .then((value) {
      // MyToast.showSuccess("Coupons created successfully", context);
      print("Succesfully updated");
    }).catchError((e) {
      MyToast.showError("Error in creating coupons : $e ", context);
      MyPrint.printOnConsole("Error in creating coupons : $e");
    });
    MyPrint.printOnConsole("IsAdded:");
    setState(() {
      isLoading = false;
    });
  }

  void getCoupon() async {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    prefixController = TextEditingController();
    maxAmountController =  TextEditingController();
    percentController =  TextEditingController();

    mobileController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    discountController = TextEditingController();
    countController = TextEditingController();
    expireTimePickerController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: SafeArea(
      child: Stack(
        children: [
          ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: SpinKitFadingCircle(
              color: primaryColor,
            ),
            color: Colors.white60,
            child: Scaffold(body: getMainBody()),
          ),
          Visibility(
              visible: isLoading,
              child: Center(
                child: Text(
                    "${Provider.of<CouponCodeProvider>(context).uploadingPer.toStringAsFixed(0).toString()}%"),
              ))
        ],
      ),
    ));
  }

  Widget getMainBody() {
    if (isFirst) {
      isFirst = false;
    }
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context)
                ? MySize.size50!
                : (Responsive.isTablet(context)
                    ? MySize.size20!
                    : MySize.size10!)),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MySize.size20!,
              ),
              getNameTextField(),
              SizedBox(
                height: MySize.size20!,
              ),
              getDiscountTypeButton(),
              SizedBox(
                height: MySize.size20!,
              ),
              _dicountTypeFields(),
              SizedBox(
                height: MySize.size20!,
              ),
              getRadioButton(),
              SizedBox(
                height: MySize.size20!,
              ),
              getCountTextField(),
              SizedBox(
                height: MySize.size30!,
              ),
              couponExpireTimeTextField(),
              checkBox(),
              SizedBox(
                height: MySize.size30!,
              ),
              Column(
                children: [
                  getAddUserButtonWidget(),
                ],
              ),
              SizedBox(
                height: MySize.size30!,
              ),
              // couponListBottomView()
            ],
          ),
        ),
      ),
    );
  }

  Widget _dicountTypeFields() {
    if (_discountType == "discount_by_amount") {
      return getDiscountAmountTextField();
    } else {
      return Column(
        children: [
          getPercentTextField(),
          SizedBox(
            height: MySize.size30!,
          ),
          getMaxAmountTextField(),
        ],
      );
    }
  }

  Widget getRadioButton() {
    return Row(
      children: [
        RadioButton(
            groupValue: _groupValue,
            value: "One_Time",
            text: "One Time",
            onChanged: (String? val) {
              _groupValue = val!;
              print(_groupValue);
              setState(() {});
            }),
        SizedBox(
          width: MySize.getScaledSizeWidth(10),
        ),
        RadioButton(
            groupValue: _groupValue,
            value: "Multiple_Time",
            text: "Multiple Time",
            onChanged: (String? val) {
              _groupValue = val!;
              print(_groupValue);
              setState(() {});
            })
      ],
    );
  }

  Widget getDiscountTypeButton() {
    return Row(
      children: [
        RadioButton(
            groupValue: _discountType,
            value: "discount_by_amount",
            text: "Discount By Amount",
            onChanged: (String? val) {
              _discountType = val!;
              print(_discountType);
              setState(() {});
            }),
        SizedBox(
          width: MySize.getScaledSizeWidth(10),
        ),
        RadioButton(
            groupValue: _discountType,
            value: "discount_by_percent",
            text: "Discount By Percent",
            onChanged: (String? val) {
              _discountType = val!;
              print(_discountType);
              setState(() {});
            })
      ],
    );
  }

  Widget RadioButton(
      {required String text,
      required String value,
      required String groupValue,
      void Function(String?)? onChanged}) {
    return Row(
      children: [
        Text(
          "$text",
          style: TextStyle(
            letterSpacing: 1,
            color: Styles.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Radio(
            activeColor: Colors.blue,
            toggleable: true,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged),
      ],
    );
  }

  Widget getNameTextField() {
    return Container(
      child: TextFormField(
        controller: prefixController,
        onChanged: (String? val) {
          if (val?.isNotEmpty ?? false) {
            prefixController!.text = val!.toUpperCase();
            prefixController!.selection =
                TextSelection.fromPosition(TextPosition(
              offset: val.length,
            ));
            setState(() {});
          }
        },
        validator: (val) {
          if (val!.isEmpty) {
            return "Prefix Cannot be empty";
          } else {
            if (val.length < 3)
              return "Length must greater than or equal to 3";
            else
              return null;
          }
        },
        textCapitalization: TextCapitalization.words,
        decoration: getTextFieldInputDecoration(
            hintText: "Prefix Name", fillColor: Colors.black),
      ),
    );
  }

  Widget getDiscountAmountTextField() {
    return Container(
      child: TextFormField(
        controller: discountController,
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val!.isEmpty) {
            return "Discount amount cannot be empty";
          } else {
            if (double.tryParse(val) == null)
              return "Not valid";
            else
              return null;
          }
        },
        decoration: getTextFieldInputDecoration(
            hintText: "Discount Amount", fillColor: Colors.black),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget getPercentTextField() {
    return Container(
      child: TextFormField(
        controller: percentController,
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val!.isEmpty) {
            return "Percent cannot be empty";
          } else {
            if (double.tryParse(val) == null)
              return "Not valid";
            else
              return null;
          }
        },
        decoration: getTextFieldInputDecoration(
            hintText: "Percentage", fillColor: Colors.black),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget getMaxAmountTextField() {
    return Container(
      child: TextFormField(
        controller: maxAmountController,
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val!.isEmpty) {
            return "Max discount amount cannot be empty";
          } else {
            if (double.tryParse(val) == null)
              return "Not valid";
            else
              return null;
          }
        },
        decoration: getTextFieldInputDecoration(
            hintText: "Max Discount Amount", fillColor: Colors.black),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget getCountTextField() {
    return Container(
      child: TextFormField(
        controller: countController,
        validator: (val) {
          if (val!.isEmpty) {
            return "Total Count cannot be empty";
          } else {
            if (double.tryParse(val) == null)
              return "Not valid";
            else
              return null;
          }
        },
        decoration: getTextFieldInputDecoration(
            hintText: "Total Count", fillColor: Colors.black),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  DateTime? pickedTime;

  Widget couponExpireTimeTextField() {
    return Container(
      child: TextFormField(
        controller: expireTimePickerController,
        readOnly: true,
        enabled: noExpirationSelected ? false : true,
        onTap: noExpirationSelected
            ? null
            : () async {
                pickedTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2001),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2025));

                if (pickedTime != null) {
                  // print(pickedTime.format(context));   //output 10:51 PM
                  // DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                  //converting to DateTime so that we can further format on different pattern.
                  // print(parsedTime); //output 1970-01-01 22:53:00.000
                  String formattedTime =
                      DateFormat('yyyy, MMMM dd').format(pickedTime!);
                  print(formattedTime); //output 14:59:00
                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                  setState(() {
                    expireTimePickerController!.text =
                        formattedTime; //set the value of text field.
                  });
                } else {
                  print("Time is not selected");
                }
              },
        // validator: (val) {
        //   if (val!.isEmpty) {
        //     return "Coupon expire time must not be empty";
        //   } else {
        //     return null;
        //   }
        // },
        decoration: getTextFieldInputDecoration(
            hintText: "Coupon expire date",
            fillColor: noExpirationSelected
                ? Colors.grey.withOpacity(0.10)
                : Colors.black),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget checkBox() {
    return CheckboxListTile(
      selected: noExpirationSelected,
      value: noExpirationSelected,
      title: Text("No Expiration"),
      onChanged: (bool? val) {
        noExpirationSelected = val!;
        setState(() {});
      },
      activeColor: Colors.blue,
      controlAffinity: ListTileControlAffinity.leading,
    );

    //   Row(
    //   children: <Widget>[
    //     SizedBox(
    //       width: 10,
    //     ), //SizedBox
    //     Text(
    //       'Liberary Implementation Of Searching Algorithm: ',
    //       style: TextStyle(fontSize: 17.0),
    //     ), //Text
    //     SizedBox(width: 10), //SizedBox
    //     /** Checkbox Widget **/
    //     Checkbox(
    //       value: noExpirationSelected,
    //       onChanged: (bool? value) {
    //         setState(() {
    //           noExpirationSelected = value!;
    //         });
    //       },
    //     ), //Checkbox
    //   ], //<Widget>[]
    // );
    //
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
        onPressed: () async {
          if (_key.currentState!.validate()) {
            MyPrint.printOnConsole("Valid");
            if (_groupValue.isEmpty) {
              MyToast.showError("Please select the type", context);
            } else {
              addCoupon();
            }
          } else {
            // if (prefixController) {
            //   MyPrint.printOnConsole("Selected Role Cannot Null");
            //   MyToast.showError("Selected Role Cannot Null", context);
            // } else if (selectedState == null || selectedState!.isEmpty) {
            //   MyPrint.printOnConsole("Selected State Cannot Null");
            //   MyToast.showError("Selected State Cannot Null", context);
            // } else if (selectedCity == null || selectedCity!.isEmpty) {
            //   MyPrint.printOnConsole("Selected City Cannot Null");
            //   MyToast.showError("Selected City Cannot Null", context);
            // }
          }
        },
        icon: Icon(Icons.add),
        label: Text("Add Coupon"),
      ),
    );
  }

  InputDecoration getTextFieldInputDecoration(
      {required String hintText, required Color fillColor}) {
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

  Widget couponListBottomView() {
    return ListView.builder(
      itemCount: couponList.length,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        return CouponCodeItemWidget(
          couponModel: couponList[index],
          index: index,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CouponCodeItemWidget extends StatefulWidget {
  CouponModel couponModel;
  int index;

  CouponCodeItemWidget({
    Key? key,
    required this.index,
    required this.couponModel,
  }) : super(key: key);

  @override
  _CouponCodeItemWidgetState createState() => _CouponCodeItemWidgetState();
}

class _CouponCodeItemWidgetState extends State<CouponCodeItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    //MyPrint.printOnConsole("Width:" + MediaQuery.of(context).size.width.toString());
    //MyPrint.printOnConsole("IsFavourite:" + widget.product.isfavourite.toString());
    return InkWell(
      onTap: () async {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MySize.size10!),
        padding: EdgeInsets.symmetric(
            vertical: MySize.size10!, horizontal: MySize.size16!),
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
              child: Text(
                "${widget.index}.",
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(
              width: MySize.size20!,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      flex: 1, child: Text("${widget.couponModel.prefix}")),
                  SizedBox(
                    width: MySize.size20!,
                  ),
                  Expanded(flex: 1, child: Text("Id")),
                  SizedBox(
                    width: MySize.size20!,
                  ),
                  // getEditButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSectionTitleText(String title) {
    return Container(
      padding: EdgeInsets.only(top: MySize.size16!),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
      ),
    );
  }

  // Widget getEnabledSelection(bool enabled) {
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
  //               widget.userModel.enabled = val;
  //             });
  //
  //             bool isUpdated = await CompanyUserController().enableCompanyUser(widget.userModel.id!, widget.userModel.enabled!);
  //
  //             if(!isUpdated) {
  //               setState(() {
  //                 widget.userModel.enabled = !val;
  //               });
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget getEditButton(CompanyUserModel companyUserModel) {
    return InkWell(
      onTap: () async {
        // NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
        // navigationProvider.selectedPageTitle = EditUserScreen.title;
        // navigationProvider.notifyListeners();
        //
        // await Navigator.pushNamed(NavigationController().homeNavigatorKey.currentContext!, EditUserScreen.routeName, arguments: companyUserModel);
        // setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(MySize.size8!),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(MySize.size20!),
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
