import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/screens/days_list.dart';
import 'package:xzone/screens/infoProfile.dart';
import 'package:xzone/screens/loading_screen.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/profile.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/screens/zones_screen.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:provider/provider.dart';

class drawer extends StatefulWidget {
  final email;
  final username;

  const drawer({this.email, this.username});

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    accountName: Text(widget.username),
                    accountEmail: Text(
                      widget.email,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => zones_profile(
                            checkMe: false,
                          ),
                        ),
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
                    onTap: () {
                      List tasks = Provider.of<TasksProvider>(context, listen: false).items;
                      List projects = Provider.of<ProjectsProvider>(context, listen: false).items;
                      if(tasks.isEmpty && projects.isEmpty)
                        Navigator.pushNamed(context, LoadingScreen.id);
                      else
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
              onTap: () async {
                await HelpFunction.removeEmail(widget.email);
                await _auth.signOut();
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
      ),
    );
  }
}
