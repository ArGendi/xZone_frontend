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
import 'package:xzone/providers/zones_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xzone/models/ZoneColor.dart';
import 'package:xzone/screens/chatroom.dart';
import 'package:xzone/screens/infoProfile.dart';
class Neewsfeed extends StatefulWidget {
  static String id = 'newsfeed';

  @override
  _NeewsfeedState createState() => _NeewsfeedState();
}

class _NeewsfeedState extends State<Neewsfeed> {
  String _email = '';
  String _userName = '';

  Future<void> getCurrentUserInfo() async{
    _email = await HelpFunction.getuserEmailsharedPrefrence();
    _userName = await HelpFunction.getuserNamesharedPrefrence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: getCurrentUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                ),
              );
            else return Container(
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView(
                      //addAutomaticKeepAlives: true,
                      children: [
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: backgroundColor),
                          accountName: Text(_userName),
                          accountEmail: Text(
                            _email,
                            style: TextStyle(color: Colors.grey),
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.black,
                          ),
                        ),
                        Divider(
                          color: whiteColor,
                          thickness: 0.06,
                        ),
                        ListTile(
                          onTap: () async{
                            int id = await HelpFunction.getUserId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => info(
                                  userId: id,
                                  checkMe: false,
                                ),),
                            );
                          },
                          title: Text(
                            "Profile",
                            style: TextStyle(color: whiteColor),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: whiteColor,
                          ),
                        ),
                        ListTile(
                          onTap: () async{
                            int id = await HelpFunction.getUserId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => infoZoneNewsfeed(
                                  userId: id,
                                ),),
                            );
                          },
                          title: Text(
                            "Zones",
                            style: TextStyle(color: whiteColor),
                          ),
                          leading: Icon(
                            Icons.group,
                            color: whiteColor,
                          ),
                        ),
                        ListTile(
                          onTap: (){
                            Navigator.pushNamed(context, DaysList.id);
                          },
                          title: Text("Tasks", style: TextStyle(color: whiteColor)),
                          leading: Icon(
                            Icons.list,
                            color: whiteColor,
                          ),
                        ),
                        Divider(
                          color: whiteColor,
                          thickness: 0.06,
                        ),
                        ListTile(
                          title:
                          Text("Settings", style: TextStyle(color: whiteColor)),
                          leading: Icon(
                            Icons.settings,
                            color: whiteColor,
                          ),
                        ),
                        ListTile(
                          title: Text("Help", style: TextStyle(color: whiteColor)),
                          leading: Icon(
                            Icons.help,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    title: Text("Logout", style: TextStyle(color: Colors.red)),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
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
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: whiteColor,
                ),
                onPressed: () {},
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ZoneWidget(
                  name: Provider.of<ZoneProvider>(context).zones[index].name,
                  numberOfmembers: Provider.of<ZoneProvider>(context)
                      .zones[index]
                      .numberOfmembers,
                  skill: Provider.of<ZoneProvider>(context).zones[index].skill,
                  admins:
                      Provider.of<ZoneProvider>(context).zones[index].admins,
                );
              },
              itemCount: Provider.of<ZoneProvider>(context).zones.length,
            ),
          ),
        ],
      ),
    );
  }
}
