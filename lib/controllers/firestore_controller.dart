import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  static FirestoreController? _instance;

  factory FirestoreController() {
    if(_instance == null) {
      _instance = FirestoreController._();
    }
    return _instance!;
  }

  FirestoreController._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
}