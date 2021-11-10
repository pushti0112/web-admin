import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/controllers/firestore_controller.dart';
import 'package:sportiwe_admin/controllers/providers/data_provider.dart';

class DataController {
  Future<Map<String, String>?> getRolesList(BuildContext context) async {
    DataProvider dataProvider = Provider.of<DataProvider>(context, listen: false);

    if(dataProvider.rolesMap == null) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection(ADMIN_COLLECTION).doc(ROLES_DOCUMENT).get();

      if(documentSnapshot.exists && documentSnapshot.data() != null && documentSnapshot.data()!.isNotEmpty) {
        dataProvider.rolesMap = Map.castFrom(documentSnapshot.data()!);
      }
    }

    return dataProvider.rolesMap;
  }

  Future<int?> getUserCounter(BuildContext context) async {
    DataProvider dataProvider = Provider.of<DataProvider>(context, listen: false);

    if(dataProvider.userCounter == null) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection(ADMIN_COLLECTION).doc(COUNTERS_DOCUMENT).get();

      if(documentSnapshot.exists && documentSnapshot.data() != null && documentSnapshot.data()!.isNotEmpty && documentSnapshot.data()!.containsKey(COMPANY_USER_COUNTER)) {
        dataProvider.userCounter = documentSnapshot.data()![COMPANY_USER_COUNTER];
      }
    }

    return dataProvider.userCounter;
  }

  Future<Map<String, dynamic>?> getPlaces() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection(ADMIN_COLLECTION).doc(PLACES_DOCUMENT).get();

    if(documentSnapshot.exists && documentSnapshot.data() != null && documentSnapshot.data()!.isNotEmpty) {
      return documentSnapshot.data()!;
    }
    return null;
  }
 

  Future<String> getNewDocId() async {
    DocumentReference documentReference = await FirestoreController().firestore.collection("admin").add({"data" : 10});
    String id = documentReference.id;
    await documentReference.delete();
    return id;
  }
  Future<Timestamp> getNewTimeStamp() async {
    DocumentReference<Map<String, dynamic>> documentReference = await FirestoreController().firestore.collection("admin").add({"data": FieldValue.serverTimestamp()});
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentReference.get();
    Timestamp timeStamp = documentSnapshot.data()!['data'];
    await documentReference.delete();
    return timeStamp;
  }
}