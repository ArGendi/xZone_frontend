import 'package:flutter/material.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:xzone/constants.dart';

class conversation extends StatefulWidget {
  final String chatRoomId;
  final String username;
  conversation({this.chatRoomId, this.username});
  @override
  _conversationState createState() => _conversationState();
}

class _conversationState extends State<conversation> {
  TextEditingController MessagetextEditingController =
      new TextEditingController();
  final firebaseDB = FirestoreDatabase();
  Stream chatmessagesStream;
  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatmessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    isSenderIsMe: snapshot.data.docs[index].data()["sendBy"] ==
                        constant.myname,
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (MessagetextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMapped = {
        "message": MessagetextEditingController.text,
        "sendBy": constant.myname,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      firebaseDB.addConversationMessages(widget.chatRoomId, messageMapped);
      MessagetextEditingController.text = "";
    }
  }

  createstream() async {
    chatmessagesStream = null;
    Stream value = await firebaseDB.getConversationMessages2(widget.chatRoomId);
    setState(() {
      chatmessagesStream = value;
    });
  }

  @override
  void initState() {
    createstream();

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          Icon(
            Icons.call,
            color: buttonColor,
          ),
          SizedBox(width: 10),
          Icon(
            Icons.video_call,
            color: buttonColor,
          ),
          SizedBox(width: 10),
          Icon(Icons.info, color: buttonColor),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        child: Stack(children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
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
                      controller: MessagetextEditingController,
                      decoration: InputDecoration(
                          hintText: "Send Message",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: buttonColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSenderIsMe;
  const MessageTile({this.message, this.isSenderIsMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSenderIsMe ? 0 : 24, right: isSenderIsMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSenderIsMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSenderIsMe
                    ? [
                        Color(0xfff7b733),
                        Color(0xfffc4a1a),
                      ]
                    : [Color(0x1AFFFFfF), Color(0x1AFFFFfF)]),
            borderRadius: isSenderIsMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child:
            Text(message, style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }
}
