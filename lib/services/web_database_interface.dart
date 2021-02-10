import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';


class DatabaseInterface {
  static Firestore fsi;
  static StreamSubscription<dynamic> listener;

  /// Does nothing in web. The app is already initialized in index.html
  initializeApp() async {
  }

  /// Retrieves the database instance
  Future<void> init(folder,Function() stopLoading, Function() startListening) async {
    fsi = firestore();
    await startListening();
    stopLoading();
  }

  disposeApp()
  {
    listener.cancel();
  }

  /// Returns true if the Collection s, Document t is actually present in the DB
  /// Returns false otherwise
  Future<bool> exists(String s, String t) async {
    return (await fsi.collection(s).doc(t).get()).exists;

  }

  /// Sets the value at Collection s, Document t
  /// with the data contained in the Map map
  set(String s, String t, Map<String, dynamic> map) async {
    return await fsi.collection(s).doc(t).set(map);

  }

  /// Returns the data contained at Collection s, Document t
  /// The Map is not sorted, the key sorting depends on last activities
  Future<Map<String, dynamic>> read(String s, String t) async {
    return (await fsi.collection(s).doc(t).get()).data();

  }

  /// Tries to update the values listed inside map
  /// inside Collection s, Document t
  /// Throws an error if the data doesn't exist
  update(String s, String t, Map<String, dynamic> map) async {

    return fsi.collection(s).doc(t).update(data: map);

  }

  /// Tries to delete the entire Document t inside Collection s
  /// Doesn't throw an error if the data doesn't exist
  delete(String s, String t) {
    fsi.collection(s).doc(t).delete();

  }

  listen(String s,callback) {
    return fsi.collection(s).onSnapshot.listen((QuerySnapshot qs){
      callback(qs.docs.map((DocumentSnapshot ss)=>[ss.id,ss.data()]
      ));

    });
  }

}