import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid; //paramater
  DatabaseService({
    this.uid, //constructer
  });

  //reference for the collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('grpups');

  //updating the collection
  Future UpdateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilPic': "",
      'uid': uid,
    });
  }
}

//medium article change flutter database rules in firestore uid = uid
