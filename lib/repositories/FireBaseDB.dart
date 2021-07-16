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

  getUserByemail(String username) async {
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

  creatingChatRoom(roomid, mappedData) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(roomid)
        .set(mappedData);
  }

  addConversationMessages(roomid, messageMapped) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(roomid)
        .collection("chats")
        .add(messageMapped);
  }

  getConversationMessages2(roomid) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(roomid)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
