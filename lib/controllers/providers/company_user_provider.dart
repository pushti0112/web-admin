import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';

class CompanyUserProvider extends ChangeNotifier {
  String? userid, userUid;
  CompanyUserModel? companyUserModel;
  User? firebaseUser;

  //Can Search by Username
  //Can Filter By Role, State, City, Enabled
  //Can Sort by Name and LastUpdated

  //For Users Search Page
  String searchedUsername = "";
  int documentLimit = 10, sortValue = 0;
  bool hasMore = true, isUsersLoading = false, isFirstTimeLoading = false;
  DocumentSnapshot? lastDocument = null;

  //For Product Filters on ProductSearchScreen
  bool enabled = true;
  String selectedRole = "", selectedState = "", selectedCity = "";
  //List<int> selectedRatingsList = [];
  List<CompanyUserModel>? searchedUsersList;
}