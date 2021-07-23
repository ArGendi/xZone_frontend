import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/days_list.dart';
import 'package:xzone/screens/loading_screen.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/profile.dart';
import 'package:xzone/screens/zoneNewsfeedInfo.dart';
import 'package:xzone/screens/zones_screen.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/widgets/ZoneWidget.dart';
import 'package:xzone/widgets/drawer.dart';
import 'package:xzone/providers/zones_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xzone/screens/generalSearch.dart';

import 'package:xzone/screens/notifications.dart';

import 'package:xzone/servcies/web_services.dart';

class Neewsfeed extends StatefulWidget {
  final email;
  final username;
  static String id = 'newsfeed';

  const Neewsfeed({this.email, this.username});
  @override
  _NeewsfeedState createState() => _NeewsfeedState();
}

class _NeewsfeedState extends State<Neewsfeed> {
  List zones;
  List Temp;
  var webService = WebServices();
  List zonesUserjoined = [];
  var userid;

  getuserZones() async {
    HelpFunction.getUserId().then((id) async {
      userid = id;
      try {
        var response = await webService
            .get('http://xzoneapi.azurewebsites.net/api/v1/ZoneMember/$id');

        zonesUserjoined =
            response.statusCode != 200 ? [] : jsonDecode(response.body);
      } catch (e) {
        print(e);
      }
    });
  }

  checkIfAlreadyJoined(zoneId) {
    bool Found = false;
    Found = zonesUserjoined.contains(zoneId);
    return Found;
  }

  beginsearchZones() async {
    try {
      var response =
          await webService.get('http://xzoneapi.azurewebsites.net/api/v1/Zone');

      Temp = jsonDecode(response.body);
      print(response.statusCode);
      setState(() {
        zones = Temp;
      });
    } catch (e) {
      print(e);
    }
  }

  myfun() {
    getuserZones();
    beginsearchZones();
  }

  @override
  void initState() {
    myfun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(
        email: widget.email,
        username: widget.username,
      ),
      appBar: AppBar(
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (contetx) => generalSearch()));
                },
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: whiteColor,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (contetx) {
                        return Notifications();
                      }));
                    },
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8,
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.facebookMessenger,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'chatroom');
                },
              ),
            ],
          ),
        ],
        iconTheme: IconThemeData(color: whiteColor),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: zones != null
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return ZoneWidget(
                        name: zones[index]["name"],
                        numberOfmembers: zones[index]["numOfMembers"],
                        description: zones[index]["description"],
                        zoneId: zones[index]["id"],
                        alreadyfound: checkIfAlreadyJoined(zones[index]["id"]),
                      );
                    },
                    itemCount: zones.length,
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
