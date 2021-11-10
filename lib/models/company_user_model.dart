import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyUserModel {
  String? id, uid, name, lowername, role, email, password, mobile, state, city,country;
  Timestamp? createdtime, lastupdatedtime;
  List<Map<String, dynamic>>? users;
  bool? enabled;

  CompanyUserModel({
    this.id,
    this.uid,
    this.name,
    this.lowername,
    this.role,
    this.email,
    this.country,
    this.password,
    this.mobile,
    this.state,
    this.city,
    this.createdtime,
    this.lastupdatedtime,
    this.users,
    this.enabled,
  });

  static CompanyUserModel fromMap(Map<String, dynamic> map) {
    String? id, uid, name, lowername, role, email, password, mobile, state, city,country;
    Timestamp? createdtime, lastupdatedtime;
    List<Map<String, dynamic>>? users;
    bool? enabled;

    id = map['id'] != null && map['id'].isNotEmpty ? map['id'].toString() : "";
    country = map['country'] != null && map['country'].isNotEmpty ? map['country'].toString() : "";
    uid = map['uid'] != null && map['uid'].isNotEmpty ? map['uid'].toString() : "";
    name = map['name'] != null && map['name'].isNotEmpty ? map['name'].toString() : "";
    lowername = map['lowername'] != null && map['lowername'].isNotEmpty ? map['lowername'].toString() : "";
    role = map['role'] != null && map['role'].isNotEmpty ? map['role'].toString() : "";
    email = map['email'] != null && map['email'].isNotEmpty ? map['email'].toString() : "";
    password = map['password'] != null && map['password'].isNotEmpty ? map['password'].toString() : "";
    mobile = map['mobile'] != null && map['mobile'].isNotEmpty ? map['mobile'].toString() : "";
    state = map['state'] != null && map['state'].isNotEmpty ? map['state'].toString() : "";
    city = map['city'] != null && map['city'].isNotEmpty ? map['city'].toString() : "";
    createdtime = map['createdtime'];
    lastupdatedtime = map['lastupdatedtime'];
    users = map['users'] != null ? List.castFrom(map['users']) : [];
    enabled = map['enabled'] != null ? map['enabled'] : false;

    return CompanyUserModel(
      id: id,
      uid: uid,
      name: name,
      country: country,
      lowername: lowername,
      role: role,
      email: email,
      password: password,
      mobile: mobile,
      city: city,
      state: state,
      createdtime: createdtime,
      lastupdatedtime: lastupdatedtime,
      users: users,
      enabled: enabled,
    );
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = map['id'] != null && map['id'].isNotEmpty ? map['id'].toString() : "";
    uid = map['uid'] != null && map['uid'].isNotEmpty ? map['uid'].toString() : "";
    name = map['name'] != null && map['name'].isNotEmpty ? map['name'].toString() : "";
    lowername = map['lowername'] != null && map['lowername'].isNotEmpty ? map['lowername'].toString() : "";
    role = map['role'] != null && map['role'].isNotEmpty ? map['role'].toString() : "";
    email = map['email'] != null && map['email'].isNotEmpty ? map['email'].toString() : "";
    password = map['password'] != null && map['password'].isNotEmpty ? map['password'].toString() : "";
    mobile = map['mobile'] != null && map['mobile'].isNotEmpty ? map['mobile'].toString() : "";
    state = map['state'] != null && map['state'].isNotEmpty ? map['state'].toString() : "";
    city = map['city'] != null && map['city'].isNotEmpty ? map['city'].toString() : "";
    country = map['country'] != null && map['country'].isNotEmpty ? map['country'].toString() : "";
    createdtime = map['createdtime'];
    lastupdatedtime = map['lastupdatedtime'];
    users = map['users'] != null ? List.castFrom(map['users']) : [];
    enabled = map['enabled'] != null ? map['enabled'] : false;
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id ?? "",
      "uid" : uid ?? "",
      "name" : name ?? "",
      "country" : country ?? "",
      "lowername" : lowername ?? "",
      "role" : role ?? "",
      "email" : email ?? "",
      "password" : password ?? "",
      "mobile" : mobile ?? "",
      "state" : state ?? "",
      "city" : city ?? "",
      "createdtime" : createdtime,
      "lastupdatedtime" : lastupdatedtime,
      "users" : users ?? [],
      "enabled" : enabled ?? false,
    };
  }
}