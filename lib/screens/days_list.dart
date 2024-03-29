import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/providers/zone_tasks_provider.dart';
import 'package:xzone/screens/profile.dart';
import 'package:xzone/screens/project_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/screens/zoneNewsfeedInfo.dart';
import 'package:xzone/screens/zones_screen.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/offline_search.dart';
import 'package:xzone/widgets/add_project.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/widgets/drawer.dart';
import 'package:xzone/widgets/project_card.dart';
import 'package:xzone/widgets/tasks_day.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'Neewsfeed.dart';
import 'infoProfile.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class DaysList extends StatefulWidget {
  static final String id = 'days list';

  @override
  _DaysListState createState() => _DaysListState();
}

class _DaysListState extends State<DaysList> {
  var globalKey = GlobalKey<FormState>();
  String _email = '';
  String _userName = '';
  final _auth = FirebaseAuth.instance;

  addTaskBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return AddTask();
        });
  }

  showAddProjectDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content: AddProject(tKey: globalKey,),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: (){
                    bool valid = globalKey.currentState.validate();
                    if(valid){
                      FocusScope.of(context).unfocus();
                      globalKey.currentState.save();
                    }
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: buttonColor
                    ),
                  )
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> getCurrentUserInfo() async{
    _email = await HelpFunction.getuserEmailsharedPrefrence();
    _userName = await HelpFunction.getuserNamesharedPrefrence();
    print("email"+_email);
    print("username"+_userName);
  }

  @override
  Widget build(BuildContext context) {
    List<Project> projectsItems =  Provider.of<ProjectsProvider>(context).items;
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Neewsfeed(
                                  email: _email,
                                  username: _userName,
                                ),
                              ),
                            );
                          },
                          title: Text("Home", style: TextStyle(color: whiteColor)),
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
                    onTap: () async{
                      await HelpFunction.removeEmail(_email);
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
            );
          },
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text('Tasks'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: buttonColor,
              ),
              onPressed: (){
                showSearch(context: context, delegate: OfflineSearch());
              }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TasksDay(
              text: 'Inbox',
              icon: Icons.inbox,
              gColor: [
                Color(0xffED213A),
                Color(0xff93291E),
              ],
              onclick: (){
                Navigator.pushNamed(context, Tasks.id, arguments: {
                  'day': 'Inbox',
                  'date': null,
                });
              },
            ),
            SizedBox(height: 10,),
            TasksDay(
              text: 'Today',
              icon: Icons.wb_sunny,
              gColor: [
                Color(0xfff7b733),
                Color(0xfffc4a1a),
              ],
              onclick: (){
                Navigator.pushNamed(context, Tasks.id, arguments: {
                  'day': 'Today',
                  'date': DateTime.now(),
                });
              },
            ),
            SizedBox(height: 10,),
            TasksDay(
              text: 'Tomorrow',
              icon: Icons.calendar_today,
              gColor: [
                Color(0xffDA4453),
                Color(0xff89216B),
              ],
              onclick: (){
                var now = DateTime.now();
                var tomDate = DateTime(now.year, now.month, now.day + 1);
                Navigator.pushNamed(context, Tasks.id, arguments: {
                  'day': 'Tomorrow',
                  'date': tomDate,
                });
              },
            ),
            SizedBox(height: 10,),
            TasksDay(
              text: 'Future',
              icon: Icons.fact_check,
              gColor: [
                Color(0xffED213A),
                Color(0xff93291E),
              ],
              onclick: (){
                var now = DateTime.now();
                var fDate = DateTime(now.year, now.month, now.day + 2);
                Navigator.pushNamed(context, Tasks.id, arguments: {
                  'day': 'Future',
                  'date': fDate,
                });
              },
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  'Projects',
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: greyColor,
                    height: 30,
                    indent: 20,
                    endIndent: 10,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: buttonColor,
                    ),
                    onPressed: showAddProjectDialog
                )
              ],
            ),
            SizedBox(height: 10,),
            if(projectsItems.isEmpty)
              Column(
                children: [
                  Image.asset(
                    'assets/images/project.png',
                    width: 250,
                  ),
                  Text(
                    'No Projects',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 18
                    ),
                  ),
                ],
              )
            else ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:  projectsItems.length,
              itemBuilder: (ctx, index){
                return Column(
                  children: [
                    ProjectCard(
                      text: projectsItems[index].name,
                      pIndex: index,
                      onClick: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectScreen(pIndex: index,),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: greyColor,
                      height: 10,
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: (){
            //Provider.of<TasksProvider>(context, listen: false).setActiveTaskDueDate(DateTime.now());
            addTaskBottomSheet();
          },
          child: Icon(Icons.add),
          backgroundColor: buttonColor,
        ),
      ),
    );
  }
}
