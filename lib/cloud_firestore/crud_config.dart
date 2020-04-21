import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class crudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      // This method use for small apps
      /*Firestore.instance
          .collection('testcrud')
          .add(carData).then((value){}).catchError((e) {print(e);}); */

      // This method use for large scale app
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference =
            await Firestore.instance.collection('testcrud');
        reference.add(carData);
      });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return await Firestore.instance
        .collection('testcrud')
        .orderBy('carName', descending: false)
        .snapshots();
  }

  updateData(selectDoc, newValues){
    Firestore.instance.collection('testcrud').document(selectDoc).updateData(newValues).catchError((e){
      print(e);
    });
  }

  deleteData(docId){
    Firestore.instance.collection('testcrud').document(docId).delete().catchError((e){
      print(e);
    });
  }
}
