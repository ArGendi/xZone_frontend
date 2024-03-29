import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/conversation.dart';
import 'package:xzone/screens/zoneNewsfeedInfo.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/RoadMapSearchTile.dart';
import 'package:xzone/widgets/zoneSearchTile.dart';

import 'infoProfile.dart';
import 'infoZone.dart';

class generalSearch extends StatefulWidget {
  @override
  _generalSearchState createState() => _generalSearchState();
}

class _generalSearchState extends State<generalSearch> {
  TextEditingController searchtextEditingController = new TextEditingController();
  final firebaseDB = FirestoreDatabase();
  List itemsusers;
  List itemszones;
  List itemsroadmaps;
  List Temp;
  var input;
  var webService = WebServices();
  var userid;
  List zonesUserjoined;
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

  beginsearch() async {
    await beginsearchUsers();
    await beginsearchZones();
    await beginsearchRoad();
  }

  beginsearchUsers() async {
    input = searchtextEditingController.text;
    try {
      var response = await webService
          .get('http://xzoneapi.azurewebsites.net/api/v1/Account/$input');

      Temp = jsonDecode(response.body);

      setState(() {
        itemsusers = Temp;
      });
    } catch (e) {
      print(e);
    }
  }

  beginsearchZones() async {
    input = searchtextEditingController.text;

    try {
      var response = await webService
          .get('http://xzoneapi.azurewebsites.net/api/v1/Zone/$input');
      Temp = jsonDecode(response.body);

      setState(() {
        itemszones = Temp;
      });
    } catch (e) {
      print(e);
    }
  }

  beginsearchRoad() async {
    input = searchtextEditingController.text;
    try {
      var response = await webService
          .get('http://xzoneapi.azurewebsites.net/api/Roadmap/$input');

      Temp = jsonDecode(response.body);
      setState(() {
        itemsroadmaps = Temp;
      });
    } catch (e) {
      print(e);
    }
  }

  checkIfAlreadyJoined(zoneId) {
    bool Found = false;

    var input = searchtextEditingController.text;

    Found = zonesUserjoined.contains(zoneId);
    return Found;
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
    return itemsusers != null
        ? ListView.builder(
            itemCount: itemsusers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: ()async{
                  int id = await HelpFunction.getUserId();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => info(
                        userId: itemsusers[index]['id'],
                        checkMe: true,
                        myId: id,
                      ),),
                  );
                },
                child: searchTileUsers(
                  name: itemsusers[index]["userName"],
                  email: itemsusers[index]["email"],
                ),
              );
            })
        : Center(
            child: Container(
              child: Text("No Results yet.",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          );
  }

  Widget searchListzones() {
    return itemszones != null
        ? ListView.builder(
            itemCount: itemszones.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: ()async{
                  int id  = await HelpFunction.getUserId();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>infoZone(
                        idUser: id,
                        idZone: itemszones[index]["id"],
                      ),
                    ),
                  );
                },
                child: ZoneSearchTile(
                  name: itemszones[index]["name"],
                  description: itemszones[index]["description"],
                  privacy: itemszones[index]["privacy"],
                  zoneId: itemszones[index]["id"],
                  alreadyYourzone: checkIfAlreadyJoined(itemszones[index]["id"]),
                ),
              );
            })
        : Center(
            child: Container(
              child: Text("No Results yet.",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          );
  }

  Widget searchListroadmaps() {
    return itemsroadmaps != null
        ? ListView.builder(
            itemCount: itemsroadmaps.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return RoadmapTile(
                name: itemsroadmaps[index]["name"],
                description: itemsroadmaps[index]["description"],
                jsoncode: itemsroadmaps[index],
              );
            })
        : Center(
            child: Container(
              child: Text("No Results yet.",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          );
  }

  Widget searchTileUsers({name, email}) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person, color: Colors.grey),
          backgroundColor: buttonColor,
        ),
        title: Text(name, style: TextStyle(color: Colors.white)),
        subtitle: Text(email, style: TextStyle(color: Colors.grey)),
        trailing: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
            child: Text("View Profile",
                style: TextStyle(
                  color: Colors.black,
                )),
            decoration: BoxDecoration(
                color: buttonColor, borderRadius: BorderRadius.circular(13))));
  }
  @override
  void initState() {
    // TODO: implement initState
    getuserZones();
    super.initState();
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
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
            ),
          ]),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(children: [
                TabBar(
                  indicatorColor: buttonColor,
                  tabs: [
                    Tab(
                      text: 'People',
                    ),
                    Tab(
                      text: 'Zones',
                    ),
                    Tab(
                      text: 'Road Maps',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    searchList(),
                    searchListzones(),
                    searchListroadmaps(),
                  ]),
                ),
              ]),
            ),
          )
        ],
      ),
    ));
  }
}

getChatRoomId(String id1, String id2, String id3, String id4) {
  if (id1.substring(0, 1).codeUnitAt(0) > id2.substring(0, 1).codeUnitAt(0)) {
    return "$id2\_$id1\#$id3$id4";
  } else {
    return "$id1\_$id2\#$id3$id4";
  }
}
