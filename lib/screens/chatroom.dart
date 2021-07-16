import 'package:flutter/material.dart';
import 'package:xzone/screens/conversation.dart';
import 'package:xzone/screens/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/repositories/FireBaseDB.dart';

class ChatRoom extends StatefulWidget {
  static String id = 'chatroom';
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _auth = FirebaseAuth.instance;
  final firebaseDB = FirestoreDatabase();
  Stream chatRoomsStream;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Chatrooms(
                    username: snapshot.data.docs[index]
                        .data()["chatroomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(constant.myname, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatroomId"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    String myname = await HelpFunction.getuserNamesharedPrefrence();

    setState(() {
      constant.myname = myname;
    });
    firebaseDB.getChatRooms(constant.myname).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          color: buttonColor,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class Chatrooms extends StatelessWidget {
  final String username;
  final String chatRoomId;
  const Chatrooms({this.username, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => conversation(
                      chatRoomId: this.chatRoomId,
                      username: this.username,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff7b733), Color(0xfffc4a1a)],
                  ),
                  borderRadius: BorderRadius.circular(40)),
              child: Text("${username.substring(0, 1).toUpperCase()}",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              username,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
