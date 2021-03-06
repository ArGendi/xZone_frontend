import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/widgets/ZoneWidget.dart';
import 'package:xzone/providers/zones_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xzone/models/ZoneColor.dart';

class Neewsfeed extends StatelessWidget {
  static String id = 'newsfeed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
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
                      accountName: Text("Nardine Nabil"),
                      accountEmail: Text(
                        "nardin1nabil@gmail.com",
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
                      title: Text("tasks", style: TextStyle(color: whiteColor)),
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
                title: Text("Logout", style: TextStyle(color: Colors.red)),
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
            ],
          ),
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
                onPressed: () {},
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
