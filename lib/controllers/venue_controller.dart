import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/controllers/firestore_controller.dart';
import 'package:sportiwe_admin/controllers/providers/company_user_provider.dart';
import 'package:sportiwe_admin/controllers/providers/data_provider.dart';
import 'package:sportiwe_admin/controllers/providers/venue_provider.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';
import 'package:sportiwe_admin/models/venue_model.dart';
import 'package:sportiwe_admin/pages/commons/widgets/toast.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/shared_pref_manager.dart';

class VenueController {
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

  Future<bool> enableVenue(String id, bool enabled, String updateField) async {
    bool isUpdated = await FirestoreController().firestore.collection(VENUES_COLLECTION).doc(id).update({"$updateField" : enabled})
        .then((value) => true)
        .catchError((e) {
          MyPrint.printOnConsole("Error in Enabling/Disabling Company User:${e}");
        });

    return isUpdated;
  }

  Future<void> getVenues(BuildContext context, bool isRefresh, {bool withnotifying = true}) async {

    VenueProvider venueProvider = Provider.of<VenueProvider>(context, listen: false);

    if (isRefresh) {
      MyPrint.printOnConsole("Refresh");
      venueProvider.isFirstTimeLoading = true;
      venueProvider.isVenuesLoading = false; // track if products fetching
      venueProvider.hasMore = true; // flag for more products available or not
      venueProvider.lastDocument = null; // flag for last document from where next 10 records to be fetched
      if(venueProvider.searchedVenuesList != null) venueProvider.searchedVenuesList!.clear();
      else venueProvider.searchedVenuesList = [];
      if(withnotifying) venueProvider.notifyListeners();
    }

    try {
      if (!venueProvider.hasMore) {
        MyPrint.printOnConsole('No More venues');
        return;
      }
      if (venueProvider.isVenuesLoading) return;
      MyPrint.printOnConsole('isUsersLoading:${venueProvider.isVenuesLoading}');

      venueProvider.isVenuesLoading = true;
      if(withnotifying) venueProvider.notifyListeners();

      MyPrint.printOnConsole("Enabled:${venueProvider.enabled}");
      //Filters Started
      Query<Map<String, dynamic>> query = FirestoreController().firestore.collection(VENUES_COLLECTION).limit(venueProvider.documentLimit);
      //For Sorting
      // if(venueProvider.searchedVenue.isEmpty) {
      //   if(venueProvider.sortValue == 0) query = query.orderBy("lastupdatedtime", descending: true);
      //   else if(venueProvider.sortValue == 1) query = query.orderBy("lastupdatedtime", descending: false);
      //   else if(venueProvider.sortValue == 2) query = query.orderBy("lowername", descending: false);
      //   else query = query.orderBy("lowername", descending: true);
      //   MyPrint.printOnConsole("Sort Value: ${venueProvider.sortValue}");
      // }

      //For Search String
      // MyPrint.printOnConsole("Search String:\'${venueProvider.searchedVenue}\'");
      // if(venueProvider.searchedVenue.isNotEmpty) {
      //   query = query.where("lowername", isGreaterThanOrEqualTo: venueProvider.searchedVenue.toLowerCase())
      //       .where("lowername", isLessThanOrEqualTo: "${venueProvider.searchedVenue.toLowerCase()}\uf8ff");
      //   query = query.orderBy("lowername", descending: (venueProvider.sortValue == 0 || venueProvider.sortValue == 3) ? true : false);
      // }

      //For Last Document
      // if(venueProvider.lastDocument != null) {
      //   MyPrint.printOnConsole("LastDocument not null");
      //   query = query.startAfterDocument(venueProvider.lastDocument!);
      // }
      // else {
      //   MyPrint.printOnConsole("LastDocument null");
      // }

      //For State
      // if(venueProvider.selectedState.isNotEmpty) query = query.where("state", isEqualTo: venueProvider.selectedState);
      // MyPrint.printOnConsole("Selected State:" + venueProvider.selectedState);

      // //For City
      // if(venueProvider.selectedCity.isNotEmpty) query = query.where("city", isEqualTo: venueProvider.selectedCity);
      // MyPrint.printOnConsole("Selected City:" + venueProvider.selectedCity);

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Snapshots:${querySnapshot.docs}");

      if (querySnapshot.docs.length < venueProvider.documentLimit) venueProvider.hasMore = false;

      if(querySnapshot.docs.length > 0) venueProvider.lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        //MyPrint.printOnConsole("Selected Colors:$selectedColors");
        venueProvider.searchedVenuesList!.add(VenueModel.fromMap(querySnapshot.docs[i].data()));
      }

      venueProvider.isFirstTimeLoading = false;
      venueProvider.isVenuesLoading = false;
      venueProvider.notifyListeners();
      MyPrint.printOnConsole("Searched Venues Length : ${venueProvider.searchedVenuesList!.length}");
    }
    catch (e) {
      MyPrint.printOnConsole("Error:" + e.toString());
      venueProvider.isVenuesLoading = false;
      if(venueProvider.searchedVenuesList != null) venueProvider.searchedVenuesList!.clear();
      else venueProvider.searchedVenuesList = [];
      venueProvider.hasMore = false;
      venueProvider.lastDocument = null;
      venueProvider.notifyListeners();
    }
  }

  void resetFilterData(BuildContext context) {
    VenueProvider venueProvider = Provider.of<VenueProvider>(context, listen: false);

    venueProvider.searchedVenue = "";
    venueProvider.enabled = true;
    venueProvider.selectedState = "";
    venueProvider.selectedCity = "";
  }

  void setFilterData(BuildContext context, {String searchVenue = "", String selectedCity = "", String selectedState = "", bool enabled = true,}) {
    VenueProvider venueProvider = Provider.of<VenueProvider>(context, listen: false);

    venueProvider.searchedVenue = searchVenue;
    venueProvider.enabled = enabled;
    venueProvider.selectedState = selectedState;
    venueProvider.selectedCity = selectedCity;

    venueProvider.notifyListeners();
  }
}