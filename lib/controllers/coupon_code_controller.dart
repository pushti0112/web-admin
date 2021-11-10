import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/controllers/data_controller.dart';
import 'package:sportiwe_admin/controllers/firestore_controller.dart';
import 'package:sportiwe_admin/controllers/providers/coupon_code_provider.dart';
import 'package:sportiwe_admin/models/coupon_code_model.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:uuid/uuid.dart';

class CouponCodeController {
  Future<void> setCoupon(
      {required BuildContext context,
      required String prefix,
      required int count,
      double? maxDiscountAmount,
      required discountType,
      int? percentage,
      double? amount,
      required String type,
      Timestamp? expiryData}) async {
    List<CouponModel> list = [];
    Uuid uid = Uuid();
    Map<String, dynamic> data = {};

    List<CouponModel> couponsList = [];

    for (int i = 0; i < count; i++) {
      String v1 = uid.v1();

      String code = v1.replaceAll("-", "").toUpperCase();
      CouponModel couponModel = CouponModel(
          prefix: "$prefix",
          type: "$type",
          discountType: discountType,
          max_discount_amount: maxDiscountAmount,
          percent: percentage,
          expiry_date: expiryData,
          code: "$prefix${code.substring(0, 8)}",
          participantList: [],
          appliedTime: null,
          createdTime: null,
          discount_amount: amount);

      couponsList.add(couponModel);
    }

    bool isSuccess = true;
    int listCount = 0;
    CouponCodeProvider couponCodeProvider =
        Provider.of<CouponCodeProvider>(context, listen: false);
    couponCodeProvider.setIndex(0.0);
    couponCodeProvider.notifyListeners();

    for (int i = 0; i < couponsList.length; i++) {
      CouponModel couponModel = couponsList[i];

      Map<String, dynamic> data = couponModel.toMap();
      data["createdTime"] = FieldValue.serverTimestamp();

      FirestoreController()
          .firestore
          .collection(COUPON_COLLECTION)
          .add(data)
          .then((value) {
        MyPrint.printOnConsole("Success $i");
      }).catchError((e) {
        isSuccess = false;
        MyToast.showError("Error in $i:$e", context);
        MyPrint.printOnConsole("Error in $i: $e");
      }).whenComplete(() {
        listCount++;
      });
    }

    while (listCount < couponsList.length) {
      await Future.delayed(Duration(milliseconds: 100));
      couponCodeProvider.setIndex((100 * ((listCount) / couponsList.length)));
      couponCodeProvider.notifyListeners();
    }
    if (isSuccess) {
      MyToast.showSuccess("Successfully uploaded", context);
    }
  }

  Future<void> deleteCoupons() async {
    //List<DocumentSnapshot<Map<String, dynamic>>>
    await FirestoreController()
        .firestore
        .collection(COUPON_COLLECTION)
        .doc()
        .delete();
  }


// Future<List<CouponModel>> getCoupons() async {
//   await FirestoreController()
//       .firestore
//       .collection(COUPON_COLLECTION)
//       .get()
//       .then((value) {
//     // MyToast.showSuccess("Coupons created successfully", context);
//     print("Succesfully updated");
//   }).catchError((e) {
//
//     // MyToast.showError("Error in creating coupons : $e ", context);
//     MyPrint.printOnConsole("Error in creating coupons : $e");
//   });
// }
}
