import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/servcies/web_services.dart';

import '../constants.dart';

class NotificationWidget extends StatefulWidget {
  final sender;
  final reciever;

  const NotificationWidget({Key key, this.sender, this.reciever})
      : super(key: key);
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  var webService = WebServices();
  var user;
  var temp;
  bool friends = false;
  getsenderusername(id) async {
    try {
      var response = await webService
          .get('http://xzoneapi.azurewebsites.net/api/v1/Account/$id');

      temp = response.statusCode != 200 ? [] : jsonDecode(response.body);
      setState(() {
        user = temp;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getsenderusername(widget.sender);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  child: Icon(Icons.person, color: Colors.grey),
                  backgroundColor: buttonColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user["userName"] + "  sent you a friend request",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 12,
                  ),
                  friends
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 45),
                          child: Text("Friends",
                              style: TextStyle(color: Colors.black)),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(13)))
                      : Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  var response = await webService.post(
                                      'http://xzoneapi.azurewebsites.net/api/v1/Friend',
                                      {
                                        "senderId": widget.sender,
                                        "receiverId": widget.reciever,
                                      });
                                  print(response.statusCode);
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      friends = true;
                                    });
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 35),
                                  child: Text("Confirm",
                                      style: TextStyle(color: Colors.black)),
                                  decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(13))),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 35),
                                child: Text("Delete",
                                    style: TextStyle(color: Colors.black)),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(13))),
                          ],
                        )
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
