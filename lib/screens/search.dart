import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:xzone/constants.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchtextEditingController =
      new TextEditingController();
  final firebaseDB = FirestoreDatabase();
  QuerySnapshot searchsnapshot;
  List items;
  List Temp;
  beginsearch() async {
    Temp = await firebaseDB.getUserByname(searchtextEditingController.text);
    setState(() {
      items = Temp;
    });
  }

  createChatroom(username, myname) {
    List<String> mappedData = [username, myname];
    firebaseDB.creatingChatRoom(mappedData);
  }

  Widget searchList() {
    return items != null
        ? ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                name: items[index]["name"],
              );
            })
        : Container();
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
          searchList()
        ],
      ),
    ));
  }
}

class searchTile extends StatelessWidget {
  final String name;

  const searchTile({this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person, color: Colors.grey),
          backgroundColor: buttonColor,
        ),
        title: Text(name, style: TextStyle(color: Colors.white)),
        trailing: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
            child: Text("message", style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
                color: buttonColor, borderRadius: BorderRadius.circular(13))));
  }
}
