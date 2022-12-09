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

  //saving the collection
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilPic': "",
      'uid': uid,
    });
  }


//medium article change flutter database rules in firestore uid = uid

//getting user data
Future gettingUserData(String email) async {
  QuerySnapshot snapshot = 
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
}

//getting user groups
getUserGroups() async {
  return userCollection.doc(uid).snapshots();
}

//creating a group
Future createGroup(String userName, String id, String groupName) async {
  DocumentReference documentReference = await groupCollection.add({

    "groupName": groupName,
    "groupIcon": "",
    "admin": "${id}_$groupName",
    "members": [],
    "groupId": "",
    "recentMessages": "",
    "recentMessageSender": "",


  });







  
};
}