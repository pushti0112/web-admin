import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/controllers/firestore_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/controllers/providers/data_provider.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/shared_pref_manager.dart';

class CompanyUserController {
  Future<bool> createCompanyUser(BuildContext context, CompanyUserModel companyUserModel) async {
    String? uid = await createEmailCredential(context, companyUserModel.email!, companyUserModel.password!);

    if(uid == null || uid.isEmpty) return false;

    MyPrint.printOnConsole("Email Created");
    companyUserModel.uid = uid;
    Map<String, dynamic> data = companyUserModel.toMap();
    data['createdtime'] = FieldValue.serverTimestamp();
    data['lastupdatedtime'] = FieldValue.serverTimestamp();

    bool isDataAdded = false;
    isDataAdded = await FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).doc(companyUserModel.id).set(data).then((value) async {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await  FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).doc(companyUserModel.id).get();
      CompanyUserModel model = CompanyUserModel.fromMap(documentSnapshot.data()!);

      Map<String, dynamic> map = {
        "users" : FieldValue.arrayUnion([
          {
            "uid" : companyUserModel.uid,
            "name" : companyUserModel.name,
            "role" : companyUserModel.role,
            "email" : companyUserModel.email,
            "password" : companyUserModel.password,
            "mobile" : companyUserModel.mobile,
            "createdtime" : model.createdtime,
            "lastupdatedtime" : model.lastupdatedtime,
          }
        ]),
      };
      await FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).doc(companyUserModel.id).update(map);

      await FirestoreController().firestore.collection(ADMIN_COLLECTION).doc(COUNTERS_DOCUMENT).update({COMPANY_USER_COUNTER : FieldValue.increment(1)});
      Provider.of<DataProvider>(context, listen: false).userCounter = null;

      return true;
    })
    .catchError((e) {
      return false;
    });

    return isDataAdded;
  }

  Future<String?> createEmailCredential(BuildContext context, String email, String password) async {
    bool isCreated = false;

    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      isCreated = true;
      if(credential.user != null) return credential.user!.uid;
    }
    on FirebaseAuthException catch(e) {
      MyToast.showError(e.message!, context);
      MyPrint.printOnConsole(e.message!);
    }
  }

  Future<bool> editCompanyUser(BuildContext context, CompanyUserModel companyUserModel) async {
    MyPrint.printOnConsole("Email Created");

    List<Map<String, dynamic>>? list = companyUserModel.users;
    Map<String, dynamic> map = list!.last as Map<String, dynamic>;
    list.remove(map);
    map['name'] = companyUserModel.name;
    map['mobile'] = companyUserModel.mobile;
    map['role'] = companyUserModel.role;
    list.add(map);

    Map<String, dynamic> data = companyUserModel.toMap();
    data['lastupdatedtime'] = FieldValue.serverTimestamp();
    data['users'] = list;

    bool isDataUpdated = false;
    isDataUpdated = await FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).doc(companyUserModel.id).update(data).then((value) async {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await  FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).doc(companyUserModel.id).get();
      companyUserModel.updateFromMap(documentSnapshot.data()!);

      return true;
    })
        .catchError((e) {
      return false;
    });

    return isDataUpdated;
  }

  Future<bool> isUserExist(BuildContext context, String uid) async {
    if(uid == null || uid.isEmpty) return false;

    Query<Map<String, dynamic>> query = FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).where("uid", isEqualTo: uid);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    List<DocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;

    MyPrint.printOnConsole("Docs:${docs}, Length:${docs.length}");

    if(docs.length > 0) {
      CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);
      CompanyUserModel companyUserModel = CompanyUserModel.fromMap(docs.first.data()!);
      companyUserProvider.companyUserModel = companyUserModel;
      companyUserProvider.userid = companyUserModel.id;
      MyPrint.printOnConsole("Model Id:${companyUserProvider.userid}");
      await SharedPrefManager().setString("userid", companyUserProvider.userid!);

      return true;
    }
    else {
      return false;
    }

    /*DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection("users").doc(uid).get();
    if(documentSnapshot.exists) {
      CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);
      Map<String, dynamic>? data = documentSnapshot.data();
      if(data != null && data.isNotEmpty) {
        if(companyUserProvider.companyUserModel == null) companyUserProvider.companyUserModel = CompanyUserModel.fromMap(data);
        else companyUserProvider.companyUserModel?.updateFromMap(data);
        *//*await SembastManager().set(SEMBAST_USERDATA, userProvider.userModel!.sembastToMap());
        await SembastManager().set(SEMBAST_USERID, userProvider.userModel!.id);*//*
      }
    }

    return documentSnapshot.exists;*/
  }

  Future<bool> enableCompanyUser(String id, bool enabled) async {
    bool isUpdated = await FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).doc(id).update({"enabled" : enabled})
        .then((value) => true)
        .catchError((e) {
          MyPrint.printOnConsole("Error in Enabling/Disabling Company User:${e}");
        });

    return isUpdated;
  }

  Future<void> getCompanyUsers(BuildContext context, bool isRefresh, {bool withnotifying = true}) async {

    CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);

    if (isRefresh) {
      MyPrint.printOnConsole("Refresh");
      companyUserProvider.isFirstTimeLoading = true;
      companyUserProvider.isUsersLoading = false; // track if products fetching
      companyUserProvider.hasMore = true; // flag for more products available or not
      companyUserProvider.lastDocument = null; // flag for last document from where next 10 records to be fetched
      if(companyUserProvider.searchedUsersList != null) companyUserProvider.searchedUsersList!.clear();
      else companyUserProvider.searchedUsersList = [];
      if(withnotifying) companyUserProvider.notifyListeners();
    }

    try {
      if (!companyUserProvider.hasMore) {
        MyPrint.printOnConsole('No More Users');
        return;
      }
      if (companyUserProvider.isUsersLoading) return;
      MyPrint.printOnConsole('isUsersLoading:${companyUserProvider.isUsersLoading}');

      companyUserProvider.isUsersLoading = true;
      if(withnotifying) companyUserProvider.notifyListeners();

      MyPrint.printOnConsole("Enabled:${companyUserProvider.enabled}");
      //Filters Started
      Query<Map<String, dynamic>> query = FirestoreController().firestore.collection(COMPANY_USERS_COLLECTION).limit(companyUserProvider.documentLimit).where("enabled", isEqualTo: companyUserProvider.enabled);

      //For Sorting
      if(companyUserProvider.searchedUsername.isEmpty) {
        if(companyUserProvider.sortValue == 0) query = query.orderBy("lastupdatedtime", descending: true);
        else if(companyUserProvider.sortValue == 1) query = query.orderBy("lastupdatedtime", descending: false);
        else if(companyUserProvider.sortValue == 2) query = query.orderBy("lowername", descending: false);
        else query = query.orderBy("lowername", descending: true);
        MyPrint.printOnConsole("Sort Value: ${companyUserProvider.sortValue}");
      }

      //For Search String
      MyPrint.printOnConsole("Search String:\'${companyUserProvider.searchedUsername}\'");
      if(companyUserProvider.searchedUsername.isNotEmpty) {
        query = query.where("lowername", isGreaterThanOrEqualTo: companyUserProvider.searchedUsername.toLowerCase())
            .where("lowername", isLessThanOrEqualTo: "${companyUserProvider.searchedUsername.toLowerCase()}\uf8ff");
        query = query.orderBy("lowername", descending: (companyUserProvider.sortValue == 0 || companyUserProvider.sortValue == 3) ? true : false);
      }

      //For Last Document
      if(companyUserProvider.lastDocument != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(companyUserProvider.lastDocument!);
      }
      else {
        MyPrint.printOnConsole("LastDocument null");
      }

      //For Role
      if(companyUserProvider.selectedRole != null && companyUserProvider.selectedRole.isNotEmpty) query = query.where("role", isEqualTo: companyUserProvider.selectedRole);
      MyPrint.printOnConsole("Selected Role:" + companyUserProvider.selectedRole);

      //For State
      if(companyUserProvider.selectedState.isNotEmpty) query = query.where("state", isEqualTo: companyUserProvider.selectedState);
      MyPrint.printOnConsole("Selected State:" + companyUserProvider.selectedState);

      //For City
      if(companyUserProvider.selectedCity.isNotEmpty) query = query.where("city", isEqualTo: companyUserProvider.selectedCity);
      MyPrint.printOnConsole("Selected City:" + companyUserProvider.selectedCity);

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Snapshots:${querySnapshot.docs}");

      if (querySnapshot.docs.length < companyUserProvider.documentLimit) companyUserProvider.hasMore = false;

      if(querySnapshot.docs.length > 0) companyUserProvider.lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        //MyPrint.printOnConsole("Selected Colors:$selectedColors");
        companyUserProvider.searchedUsersList!.add(CompanyUserModel.fromMap(querySnapshot.docs[i].data()));
      }

      companyUserProvider.isFirstTimeLoading = false;
      companyUserProvider.isUsersLoading = false;
      companyUserProvider.notifyListeners();
      MyPrint.printOnConsole("Searched Products Length : ${companyUserProvider.searchedUsersList!.length}");
    }
    catch (e) {
      MyPrint.printOnConsole("Error:" + e.toString());
      companyUserProvider.isUsersLoading = false;
      if(companyUserProvider.searchedUsersList != null) companyUserProvider.searchedUsersList!.clear();
      else companyUserProvider.searchedUsersList = [];
      companyUserProvider.hasMore = false;
      companyUserProvider.lastDocument = null;
      companyUserProvider.notifyListeners();
    }
  }

  void resetFilterData(BuildContext context) {
    CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);

    companyUserProvider.searchedUsername = "";
    companyUserProvider.enabled = true;
    companyUserProvider.selectedRole = "";
    companyUserProvider.selectedState = "";
    companyUserProvider.selectedCity = "";
  }

  void setFilterData(BuildContext context, {String searchUser = "", String selectedRole = "", String selectedCity = "", String selectedState = "", bool enabled = true,}) {
    CompanyUserProvider companyUserProvider = Provider.of<CompanyUserProvider>(context, listen: false);

    companyUserProvider.searchedUsername = searchUser;
    companyUserProvider.enabled = enabled;
    companyUserProvider.selectedRole = selectedRole;
    companyUserProvider.selectedState = selectedState;
    companyUserProvider.selectedCity = selectedCity;

    companyUserProvider.notifyListeners();
  }
}