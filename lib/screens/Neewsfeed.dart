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

import 'createNewZone.dart';
import 'infoZone.dart';

class Neewsfeed extends StatefulWidget {
  final email;
  final username;
  static String id = 'newsfeed';
   final bool register;
   final int registerId;

  const Neewsfeed({this.email, this.username, this.register, this.registerId});
  @override
  _NeewsfeedState createState() => _NeewsfeedState();
}

class _NeewsfeedState extends State<Neewsfeed> {
  List zones=[];
  List Temp=[];
  var webService = WebServices();
  List zonesUserjoined = [];
  var userid;

  getuserZones() async {
    HelpFunction.getUserId().then((id) async {
      userid = id;
      print("my zones");
      print(userid);
      try {
        if(widget.register) userid = widget.registerId;
        var response = await webService
            .get('http://xzoneapi.azurewebsites.net/api/v1/ZoneMember/$userid');
        print("zone recommender"+response.statusCode.toString());
        setState(() {
          zonesUserjoined =
              response.statusCode != 200 ? [] : jsonDecode(response.body);
        });


      } catch (e) {
        print(e);
      }
    });
  }

  checkIfAlreadyJoined(zoneId) {
    bool Found = false;
    Found = zonesUserjoined.contains(zoneId);
    print(Found);
    return Found;
  }

  beginsearchZones() async {
    HelpFunction.getUserId().then((id) async {
      userid = id;
      try {

      var response =
          await webService.get('http://xzoneapi.azurewebsites.net/api/v1/Zone/GetZone/ZoneRecommender/$id');
      Temp = jsonDecode(response.body);
      print(response.statusCode);
      print(id);
      print(Temp);
      setState(() {
        zones = Temp;
      });
    } catch (e) {
      print(e);
    }
  });
        }
  myfun()async {
    // getuserZones();
    beginsearchZones();
  }

  @override
  void initState() {
    myfun();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(
        email: widget.email,
        username: widget.username,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewZone(),
              ),
            );

          },
          child: Icon(Icons.add),
          backgroundColor: buttonColor,
        ),
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
            child: Temp != null
                ? zonesUserjoined.length == Temp.length?Center(
      child: Container(
          child: Text("No Zones Found",
          style: TextStyle(
            color: Colors.white,
          )),
    ),
    ):
            ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: ()async{
                          int id = await HelpFunction.getUserId();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>infoZone(
                                idUser: id,
                                idZone: zones[index]['id'],
                              ),
                            ),
                          );
                        },
                        child: ZoneWidget(
                          name: zones[index]["name"],
                          numberOfmembers: zones[index]["numOfMembers"],
                          description: zones[index]["description"],
                          zoneId: zones[index]["id"],
                          alreadyfound: checkIfAlreadyJoined(zones[index]["id"]),
                        ),
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
