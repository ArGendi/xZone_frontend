import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/screens/project_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/servcies/tasks_search.dart';
import 'package:xzone/widgets/add_project.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/widgets/project_card.dart';
import 'package:xzone/widgets/tasks_day.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'login_screen.dart';

class DaysList extends StatefulWidget {
  static final String id = 'days list';

  @override
  _DaysListState createState() => _DaysListState();
}

class _DaysListState extends State<DaysList> {
  var globalKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    List<Project> projectsItems =  Provider.of<ProjectsProvider>(context).items;
    return Scaffold(
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
                showSearch(context: context, delegate: TasksSearch());
              }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
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
            Provider.of<TasksProvider>(context, listen: false).setActiveTaskDueDate(DateTime.now());
            addTaskBottomSheet();
          },
          child: Icon(Icons.add),
          backgroundColor: buttonColor,
        ),
      ),
    );
  }
}
