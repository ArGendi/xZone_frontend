import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/conversation.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchtextEditingController =
      new TextEditingController();
  final firebaseDB = FirestoreDatabase();
  List items;
  List Temp;
  beginsearch() async {
    Temp = await firebaseDB.getUserByname(searchtextEditingController.text);
    setState(() {
      items = Temp;
    });
  }

  createChatroom(username, email) {
    String id =
        getChatRoomId(email, constant.myemail, username, constant.myname);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => conversation(
                chatRoomId: id, username: username, email: email)));
  }

  Widget searchList() {
    return items != null
        ? ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                  name: items[index]["name"], email: items[index]["email"]);
            })
        : Container();
  }

  Widget searchTile({name, email}) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person, color: Colors.grey),
          backgroundColor: buttonColor,
        ),
        title: Text(name, style: TextStyle(color: Colors.white)),
        subtitle: Text(email, style: TextStyle(color: Colors.grey)),
        trailing: GestureDetector(
          onTap: () {
            createChatroom(name, email);
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
              child: Text("message", style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(13))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
      child: Column(
        children: [
          Row(children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black45,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: searchtextEditingController,
                      decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        beginsearch();
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    ));
  }
}

getChatRoomId(String id1, String id2, String id3, String id4) {
  if (id1.substring(0, 1).codeUnitAt(0) > id2.substring(0, 1).codeUnitAt(0) &&
      (id3.substring(0, 1).codeUnitAt(0) > id4.substring(0, 1).codeUnitAt(0))) {
    return "$id2\_$id1\#$id4$id3";
  } else {
    return "$id1\_$id2\#$id3$id4";
  }
}
