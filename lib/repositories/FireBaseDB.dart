import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  getUserByname(String username) async {
    var items = List<dynamic>();
    await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get()
        .then((QuerySnapshot querysnapshot) {
      querysnapshot.docs.forEach((element) {
        items.add(element.data());
      });
    });
    return items;
  }

  uploadUserInfo(data) {
    FirebaseFirestore.instance.collection("users").add(data);
  }

  creatingChatRoom(mappedData) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc("username_username2")
        .set(mappedData);
  }
}
