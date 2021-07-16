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
  String lastmess;
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
                        .substring(snapshot.data.docs[index]
                                .data()["chatroomId"]
                                .toString()
                                .indexOf("#") +
                            1)
                        .replaceAll(
                            constant.myname != null ? constant.myname : "", ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatroomId"],
                    email: snapshot.data.docs[index]
                        .data()["chatroomId"]
                        .toString()
                        .replaceAll(
                            snapshot.data.docs[index]
                                .data()["chatroomId"]
                                .toString()
                                .substring(snapshot.data.docs[index]
                                    .data()["chatroomId"]
                                    .toString()
                                    .indexOf("#")),
                            "")
                        .replaceAll(constant.myemail, "")
                        .replaceAll("_", ""),
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
    User myuser = await _auth.currentUser;
    //   var username = myuser.displayName;
    var email = myuser.email;

    setState(() {
      constant.myname = myname;
      // constant.myname = username;
      constant.myemail = email;
    });
    firebaseDB.getChatRooms(constant.myemail).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Chats",
            style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w800)),
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Icon(
          Icons.search,
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
  final String email;
  const Chatrooms({this.username, this.chatRoomId, this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => conversation(
                        chatRoomId: this.chatRoomId,
                        username: this.username,
                        email: this.email,
                      )));
        },
        child: Container(
          color: Colors.black12,
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
              Column(
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
