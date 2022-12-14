import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  /* ------------------------------- References ------------------------------- */

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  /* ---------------------------- Saving User Data ---------------------------- */

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "email": email,
      "fullName": fullName,
      "groups": [],
      "uid": uid,
    });
  }

  /* ---------------------------- Getting User Data --------------------------- */

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  /* ---------------------------- Getting Groups Data --------------------------- */

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  /* ----------------------------- Creating Groups ---------------------------- */

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    /* ----------------------------- Update Members ----------------------------- */

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);

    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }
}
