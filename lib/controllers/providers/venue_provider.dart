import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sportiwe_admin/models/company_user_model.dart';
import 'package:sportiwe_admin/models/venue_model.dart';

class VenueProvider extends ChangeNotifier {
  //Can Search by Username
  //Can Filter By Role, State, City, Enabled
  //Can Sort by Name and LastUpdated

  //For Users Search Page
  String searchedVenue = "";
  int documentLimit = 10, sortValue = 0;
  bool hasMore = true, isVenuesLoading = false, isFirstTimeLoading = false;
  DocumentSnapshot? lastDocument = null;

  //For Product Filters on ProductSearchScreen
  bool enabled = true;
  String selectedState = "", selectedCity = "";
  List<VenueModel>? searchedVenuesList;
  
}