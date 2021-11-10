import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportiwe_admin/models/coupon_participant_model.dart';
import 'package:sportiwe_admin/utils/date_presentation.dart';

class CouponModel {
  String? id, code, prefix, type, discountType;
  double? discount_amount, max_discount_amount;
  int? percent;
  Timestamp? expiry_date,createdTime,appliedTime;
  List<CouponParticipantModel>? participantList;

  CouponModel({
    this.id,this.code, this.prefix, this.type, this.discountType,
    this.discount_amount, this.max_discount_amount,
    this.percent,
    this.expiry_date, this.createdTime, this.appliedTime,
    this.participantList,
  });

  static CouponModel fromMap(String docId, Map<String, dynamic> map) {
    String? id, code, prefix, type, discountType;
    double? discount_amount, max_discount_amount;
    int? percent;
    Timestamp? expiry_date,createdTime,appliedTime;
    List<CouponParticipantModel>? participantList;

    id = docId;
    code = map['code'] != null ? map['code'].toString() : "";
    prefix = map['prefix'] != null ? map['prefix'].toString() : "";
    type = map['type'] != null ? map['type'].toString() : "";
    discountType = map['discountType'] != null ? map['discountType'].toString() : "";
    discount_amount = map['discount_amount'] != null ? map['discount_amount'].toDouble() : 0.0;
    max_discount_amount = map['max_discount_amount'] != null ? map['max_discount_amount'].toDouble() : 0.0;
    percent = map['percent'] != null ? map['percent'] : 0;
    expiry_date = map['expiry_date'];
    createdTime = map['createdTime'];
    appliedTime = map['applyTime'];

    participantList = [];
    List<Map<String, dynamic>>? participantMapList = [];
    participantMapList = map['participantList'] != null ? List.from(List.castFrom(map['participantList'])) : [];
    participantMapList.forEach((element) {
      participantList!.add(CouponParticipantModel.fromMap(element));
    });

    return CouponModel(
      id:id,
      code: code,
      prefix: prefix,
      type: type,
      discountType: discountType,
      discount_amount: discount_amount,
      max_discount_amount: max_discount_amount,
      percent: percent,
      appliedTime: appliedTime,
      createdTime: createdTime,
      expiry_date: expiry_date,
      participantList: participantList,
    );
  }

  static CouponModel elasticFromMap(String docId, Map<String, dynamic> map) {
    String? id, code, prefix, type, discountType;
    double? discount_amount, max_discount_amount;
    int? percent;
    Timestamp? expiry_date,createdTime,appliedTime;
    List<CouponParticipantModel>? participantList;

    id = docId;
    code = map['code'] != null ? map['code'].toString() : "";
    prefix = map['prefix'] != null ? map['prefix'].toString() : "";
    type = map['type'] != null ? map['type'].toString() : "";
    discountType = map['discountType'] != null ? map['discountType'].toString() : "";
    discount_amount = map['discount_amount'] != null ? map['discount_amount'].toDouble() : 0.0;
    max_discount_amount = map['max_discount_amount'] != null ? map['max_discount_amount'].toDouble() : 0.0;
    percent = map['percent'] != null ? map['percent'] : 0;
    appliedTime = map['expiry_date'] != null && map['expiry_date'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['expiry_date'])) : null;
    createdTime = map['createdTime'] != null && map['createdTime'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['createdTime'])) : null;
    appliedTime = map['appliedTime'] != null && map['appliedTime'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['appliedTime'])) : null;

    participantList = [];
    List<Map<String, dynamic>>? participantMapList = [];
    participantMapList = map['participantList'] != null ? List.from(List.castFrom(map['participantList'])) : [];
    participantMapList.forEach((element) {
      participantList!.add(CouponParticipantModel.elasticFromMap(element));
    });

    return CouponModel(
      id:id,
      code: code,
      prefix: prefix,
      type: type,
      discountType: discountType,
      discount_amount: discount_amount,
      max_discount_amount: max_discount_amount,
      percent: percent,
      appliedTime: appliedTime,
      createdTime: createdTime,
      expiry_date: expiry_date,
      participantList: participantList,
    );
  }

  void updateFromMap(String docId, Map<String, dynamic> map) {
    id = docId;
    code = map['code'] != null ? map['code'].toString() : "";
    prefix = map['prefix'] != null ? map['prefix'].toString() : "";
    type = map['type'] != null ? map['type'].toString() : "";
    discountType = map['discountType'] != null ? map['discountType'].toString() : "";
    discount_amount = map['discount_amount'] != null ? map['discount_amount'].toDouble() : 0.0;
    max_discount_amount = map['max_discount_amount'] != null ? map['max_discount_amount'].toDouble() : 0.0;
    percent = map['percent'] != null ? map['percent'] : 0;
    expiry_date = map['expiry_date'];
    createdTime = map['createdTime'];
    appliedTime = map['applyTime'];

    participantList = [];
    List<Map<String, dynamic>>? participantMapList = [];
    participantMapList = map['participantList'] != null ? List.from(List.castFrom(map['participantList'])) : [];
    participantMapList.forEach((element) {
      participantList!.add(CouponParticipantModel.fromMap(element));
    });
  }

  void elasticUpdateFromMap(String docId, Map<String, dynamic> map) {
    id = docId;
    code = map['code'] != null ? map['code'].toString() : "";
    prefix = map['prefix'] != null ? map['prefix'].toString() : "";
    type = map['type'] != null ? map['type'].toString() : "";
    discountType = map['discountType'] != null ? map['discountType'].toString() : "";
    discount_amount = map['discount_amount'] != null ? map['discount_amount'].toDouble() : 0.0;
    max_discount_amount = map['max_discount_amount'] != null ? map['max_discount_amount'].toDouble() : 0.0;
    percent = map['percent'] != null ? map['percent'] : 0;
    appliedTime = map['expiry_date'] != null && map['expiry_date'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['expiry_date'])) : null;
    createdTime = map['createdTime'] != null && map['createdTime'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['createdTime'])) : null;
    appliedTime = map['appliedTime'] != null && map['appliedTime'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['appliedTime'])) : null;

    participantList = [];
    List<Map<String, dynamic>>? participantMapList = [];
    participantMapList = map['participantList'] != null ? List.from(List.castFrom(map['participantList'])) : [];
    participantMapList.forEach((element) {
      participantList!.add(CouponParticipantModel.elasticFromMap(element));
    });
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id ?? "";
    data["code"] = code ?? "";
    data["prefix"] = prefix ?? "";
    data["type"] = type ?? "";
    data["discountType"] = discountType ?? "";
    data["discount_amount"] = discount_amount ?? 0.0;
    data["max_discount_amount"] = max_discount_amount ?? 0.0;
    data["percent"] = percent ?? 0;
    data["expiry_date"] = expiry_date;
    data["appliedTime"] = appliedTime;
    data["createdTime"] = createdTime;

    List<Map<String, dynamic>> participantsMapList = [];
    participantList?.forEach((element) {
      participantsMapList.add(element.toMap());
    });
    data["participantList"] = participantsMapList;

    return data;
  }

  Map<String, dynamic> elasticToMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id ?? "";
    data["code"] = code ?? "";
    data["prefix"] = prefix ?? "";
    data["type"] = type ?? "";
    data["discountType"] = discountType ?? "";
    data["discount_amount"] = discount_amount ?? 0.0;
    data["max_discount_amount"] = max_discount_amount ?? 0.0;
    data["percent"] = percent ?? 0;
    data["expiry_date"] = expiry_date != null ? DatePresentation.yyyyMMddHHmmssFormatter(expiry_date!) : null;
    data["appliedTime"] = appliedTime != null ? DatePresentation.yyyyMMddHHmmssFormatter(appliedTime!) : null;
    data["createdTime"] = createdTime != null ? DatePresentation.yyyyMMddHHmmssFormatter(createdTime!) : null;

    List<Map<String, dynamic>> participantsMapList = [];
    participantList?.forEach((element) {
      participantsMapList.add(element.elasticToMap());
    });
    data["participantList"] = participantsMapList;

    return data;
  }

  @override
  String toString() {
    return "[ID:${id}, Code:${code}, Discount Amount:${discount_amount}, Type:${type}, Prefix:${prefix}, Expiry Date:${expiry_date},"
        " ParticipantsList:${participantList}, Applied Time:${appliedTime}, Created Time:${createdTime}]";
  }
}