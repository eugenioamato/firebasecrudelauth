import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DatabaseInterface {

  static FirebaseFirestore firestore;

   /// Creates the Firebase connection, only needed in mobile version.
   /// (The Web version is connected in the index.html file)
  initializeApp() async {
    if (!kIsWeb)
    await Firebase.initializeApp();
  }
  /// Retrieves the database instance
  void init() {
    firestore= FirebaseFirestore.instance;
  }

  /// Returns true if the Collection s, Document t is actually present in the DB
  /// Returns false otherwise
  Future<bool> exists(String s, String t) async {
    return (await firestore.collection(s).doc(t).get()).exists;
  }

  /// Sets the value at Collection s, Document t
  /// with the data contained in the Map map
   set(String s, String t, Map<String, dynamic> map) async {
   return await firestore.collection(s).doc(t).set(map);

  }

  /// Returns the data contained at Collection s, Document t
  /// The Map is not sorted, the key sorting depends on last activities
  Future<Map<String, dynamic>> read(String s, String t) async {
    return (await firestore.collection(s).doc(t).get()).data();

  }

  /// Tries to update the values listed inside map
  /// inside Collection s, Document t
  /// Throws an error if the data doesn't exist
   update(String s, String t, Map<String, dynamic> map) async {

    return firestore.collection(s).doc(t).update(
      map);
  }

  /// Tries to delete the entire Document t inside Collection s
  /// Doesn't throw an error if the data doesn't exist
   delete(String s, String t) {
    firestore.collection(s).doc(t).delete();
  }

}