import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/notificationWidget.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List notifications;
  var webService = WebServices();
  var userid;
  List sendersusernames;
  List Temp;
  getuserFriendRequests() async {
    HelpFunction.getUserId().then((id) async {
      userid = id;
      try {
        var response = await webService.get(
            'http://xzoneapi.azurewebsites.net/api/v1/FriendRequest/Received/$id');

        Temp = response.statusCode != 200 ? [] : jsonDecode(response.body);
        setState(() {
          notifications = Temp;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    getuserFriendRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Notifications",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: notifications != null
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return NotificationWidget(
                        sender: notifications[index],
                        reciever: userid,
                      );
                    },
                    itemCount: notifications.length,
                  )
                : Center(
                    child: Container(
                      child: Text("No Results yet.",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
