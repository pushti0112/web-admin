import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportiwe_admin/utils/date_presentation.dart';

class CouponParticipantModel {
  String? userid;
  Timestamp? appliedTime;

  CouponParticipantModel({
    this.userid,
    this.appliedTime,
  });

  static CouponParticipantModel fromMap(Map<String, dynamic> map) {
    String? userid;
    Timestamp? appliedTime;

    userid = map['userid'] != null ? map['userid'].toString() : "";
    appliedTime = map['appliedTime'];

    return CouponParticipantModel(
      userid: userid,
      appliedTime: appliedTime,
    );
  }

  static CouponParticipantModel elasticFromMap(Map<String, dynamic> map) {
    String? userid;
    Timestamp? appliedTime;

    userid = map['userid'] != null ? map['userid'].toString() : "";
    appliedTime = map['appliedTime'] != null && map['appliedTime'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['appliedTime'])) : null;

    return CouponParticipantModel(
      userid: userid,
      appliedTime: appliedTime,
    );
  }

  void updateFromMap(Map<String, dynamic> map) {
    userid = map['userid'] != null ? map['userid'].toString() : "";
    appliedTime = map['appliedTime'];
  }

  void elasticUpdateFromMap(Map<String, dynamic> map) {
    userid = map['userid'] != null ? map['userid'].toString() : "";
    appliedTime = map['appliedTime'] != null && map['appliedTime'].isNotEmpty ? Timestamp.fromDate(DateTime.parse(map['appliedTime'])) : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["userid"] = userid ?? "";
    data["appliedTime"] = appliedTime;
    return data;
  }

  Map<String, dynamic> elasticToMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["userid"] = userid ?? "";
    data["appliedTime"] = appliedTime != null ? DatePresentation.yyyyMMddHHmmssFormatter(appliedTime!) : null;
    return data;
  }

  @override
  String toString() {
    return "[Userid:${userid}, Code:${appliedTime},]";
  }
}