import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:xzone/screens/ZoneTest.dart';
import 'package:xzone/screens/friends_screen.dart';
import 'package:xzone/screens/skills.dart';
import 'package:xzone/screens/zones_screen.dart';
import 'package:provider/provider.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';

import 'conversation.dart';

class profile extends StatefulWidget {
  static String id = 'profile';
  final bool checkMe;
  final int userId;
  final String userName;
  final String bio;
  final int rank;
  final List badges;
  final List roadMaps;
  final List zones;
  final List friends;
  final bool checkFriedns;
  final List skills;
  final String email;
  const profile(
      {Key key,
      this.checkMe,
      this.userName,
      this.bio,
      this.rank,
      this.badges,
      this.roadMaps,
      this.zones,
      this.userId,
      this.friends,
      this.checkFriedns,
      this.skills,
      this.email})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return profileState();
  }
}

class profileState extends State<profile> {
  List<Color> colors1 = [
    Color(0xFFE8CBC0),
    Color(0xFFFDC830),
    Color(0xFF373B44),
    Color(0xFF3E5151)
  ];
  List<Color> colors2 = [
    Color(0xFF636FA4),
    Color(0xFFF37335),
    Color(0xFF4286f4),
    Color(0xFFDECBA4)
  ];
  int indeex = 0;
  bool isMe=false;
  Color getRankColor(int rank) {
    switch (rank) {
      case 0:
        return bronze;
      case 1:
        return silver;
      case 2:
        return gold;
      case 3:
        return platinum;
    }
  }

  final _auth = FirebaseAuth.instance;
  final firebaseDB = FirestoreDatabase();
  Stream chatRoomsStream;
  getcurrentuser() async {
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

  createChatroom(username, email) async {
    HelpFunction.getuserNamesharedPrefrence().then((myName) {
      HelpFunction.getuserEmailsharedPrefrence().then((myEmail) {
        print("username" + username);
        print("email" + email);
        print(myName);
        print(myEmail);

        String id = getChatRoomId(email, myEmail, username, myName);
        print(id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => conversation(
                      chatRoomId: id,
                      username: username,
                      email: email,
                      myEmail: myEmail,
                    )));
      });
    });
  }

  getChatRoomId(String id1, String id2, String id3, String id4) {
    if (id1.substring(0, 1).codeUnitAt(0) > id2.substring(0, 1).codeUnitAt(0) &&
        (id3.substring(0, 1).codeUnitAt(0) >
            id4.substring(0, 1).codeUnitAt(0))) {
      return "$id2\_$id1\#$id4$id3";
    } else {
      return "$id1\_$id2\#$id3$id4";
    }
  }
  var webService = WebServices();
  Addfriend(int firstUserId, int secondUserID) async {
    var response = await webService.post(
        'http://xzoneapi.azurewebsites.net/api/v1/FriendRequest',
        {"senderId": firstUserId, "receiverId": secondUserID});
    print(response.statusCode);
  }

  int basicUserId;
  bool friend =false;
  getuserId(int secondUserID) async {
    basicUserId = await HelpFunction.getUserId();
    Addfriend(basicUserId, secondUserID);
  }

  showAddSectionDialog(String name, String Desc, roadMap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadiusValue))),
          content: ListTile(
            leading: Icon(
              Icons.add_task,
              color: buttonColor,
            ),
            title: Text(
              name,
              style: TextStyle(color: whiteColor, fontSize: 20),
            ),
            subtitle: Text(
              Desc,
              style: TextStyle(color: whiteColor),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: buttonColor),
                  )),
            ),
            if (widget.checkMe)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    onPressed: () {
                      Project project = new Project(name);
                      project.description = Desc;
                      project.id = roadMap['id'];
                      project.userID = roadMap['ownerID'];
                      Provider.of<ProjectsProvider>(context, listen: false)
                          .addProject(project, true);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Get',
                      style: TextStyle(color: buttonColor),
                    )),
              ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
     HelpFunction.getUserId().then((value) {
       if(value == widget.userId) setState(() {
         isMe = true;
       });
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      home: Scaffold(
        backgroundColor: Color(0xFF191720),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF191720),
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(
              color: whiteColor,
              fontSize: 25,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: buttonColor,
          ),
        ),
        body: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () async {
                        int id = await HelpFunction.getUserId();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => friends(
                              checkMe: widget.checkMe,
                              FriendList: widget.friends,
                              userId: widget.userId,
                              myId: id,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Friends',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            widget.friends.length.toString(),
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 130,
                    width: 130,
                    child: Card(
                      color: backgroundColor,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/pro.png"),
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: getRankColor(widget.rank),
                          blurRadius: 5.0,
                          offset: Offset(0, 4),
                          spreadRadius: 0.8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => zones_profile(
                              checkMe: widget.checkMe,
                              userID: widget.userId,
                              zones: widget.zones,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Zones',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            widget.zones.length.toString(),
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              // padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: Container(
                child: Text(
                  widget.userName,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.bio.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  widget.bio,
                  style: TextStyle(color: whiteColor, fontSize: 15),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            !isMe?
              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    if (!widget.checkFriedns)
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            friend?"Request Sent":"Add Friend",
                            style: TextStyle(color: whiteColor, fontSize: 15),
                          ),
                          onPressed: () async {
                            try {
                              int id = await HelpFunction.getUserId();
                              var response = await webService.post(
                                  'http://xzoneapi.azurewebsites.net/api/v1/FriendRequest',
                                  {
                                    "senderId": id,
                                    "receiverId": widget.userId,
                                  });
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                setState(() {
                                  friend = true;
                                });
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: buttonColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.circular(borderRadiusValue)),
                        ),
                      ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text(
                          "Chat",
                          style: TextStyle(color: whiteColor, fontSize: 15),
                        ),
                        onPressed: () {
                          getcurrentuser().then((value) {
                            createChatroom(widget.userName, widget.email);
                          });
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: buttonColor,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ):Card(),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: greyColor,
              thickness: 2,
              height: 30,
            ),
            Center(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Skills',
                          style: TextStyle(
                              color: buttonColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    HelpFunction.getUserId()==widget.userId?
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: buttonColor,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Skills(),
                            ),
                          );
                        },
                      ),
                    ):Card(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.skills.length,
                itemBuilder: (BuildContext context, int index) {
                  indeex = index;
                  if (indeex >= colors1.length) {
                    indeex = indeex % colors1.length;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      height: 100,
                      width: 170,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            zonescolor[indeex].firstColor,
                            zonescolor[indeex].secondColor,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.skills[index]['skill']['name'],
                          style: TextStyle(
                            fontSize: 25,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: greyColor,
              thickness: 2,
              height: 30,
            ),
            Center(
              child: Container(
                child: Text(
                  'Badges',
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            widget.badges.length != 0
                ? Container(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.badges.length,
                        itemBuilder: (BuildContext context, int index) {
                          String imageUrl = '';
                          String imageName = '';
                          switch (widget.badges[index]['badgeID']) {
                            case 2:
                              imageUrl = 'assets/images/5taskfinished.png';
                              imageName = "5 Tasks";
                              break;
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: (50),
                                  backgroundColor: buttonColor,
                                  child: Image.asset(imageUrl),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  imageName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: (70),
                        backgroundColor: backgroundColor,
                        child: Image.asset("assets/images/empty.png"),
                      ),
                      Text(
                        'Work Hard To Get Badges',
                        style: TextStyle(
                          color: buttonColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
            Divider(
              color: greyColor,
              thickness: 2,
              height: 30,
            ),
            Center(
              child: Container(
                child: Text(
                  'RoadMap',
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            widget.roadMaps.length != 0
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: widget.roadMaps.length,
                    itemBuilder: (BuildContext context, int index) {
                      indeex = index;
                      if (indeex >= colors1.length) {
                        indeex = indeex % colors1.length;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  zonescolor[indeex].firstColor,
                                  zonescolor[indeex].secondColor,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.roadMaps[index]['name'],
                                style: TextStyle(
                                  fontSize: 25,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            showAddSectionDialog(
                                widget.roadMaps[index]['name'],
                                widget.roadMaps[index]['description'],
                                widget.roadMaps[index]);
                          },
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      CircleAvatar(
                        radius: (50),
                        backgroundColor: backgroundColor,
                        child: Image.asset("assets/images/roadmap.png"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'No RoadMap Yet',
                        style: TextStyle(
                          color: buttonColor,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
