import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/providers/zone_tasks_provider.dart';
import 'package:xzone/screens/days_list.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import '../constants.dart';

class LoadingScreen extends StatefulWidget {
  static final String id = 'loading';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  DBHelper _dbHelper = new DBHelper();
  WebServices _webServices = new WebServices();

  _getDataFromOfflineDB() async{
    Provider.of<TasksProvider>(context, listen: false).clearProviderItems();
    Provider.of<ProjectsProvider>(context, listen: false).clearProviderItems();
    Provider.of<ZoneTasksProvider>(context, listen: false).clearProviderItems();
    await _dbHelper.deleteAllZoneTask(tasksTable);

    await Provider.of<TasksProvider>(context, listen: false)
        .fetchAndSetData();
    await Provider.of<ProjectsProvider>(context, listen: false)
        .fetchAndSetData();

    int id = await HelpFunction.getUserId();
    var response = await _webServices.get('http://xzoneapi.azurewebsites.net/api/v1/AccountZoneTask/$id');
    if(response.statusCode == 200){
      var body = jsonDecode(response.body);
      for(var item in body){
        if(item['completeDate'] != null) continue;
        Task task = new Task();
        task.id = item['zoneTaskID'];
        task.userId = item['accountID'];
        task.name = item['zoneTask']['name'];
        task.priority = item['zoneTask']['priority'] == null ? 100 : item['zoneTask']['priority'];
        task.parentId = item['zoneTask']['parentID'];
        if(item['zoneTask']['dueDate'] != null) task.dueDate = DateTime.parse(item['zoneTask']['dueDate']);
        else task.dueDate = null;
        if(item['zoneTask']['remainder'] != null) task.remainder = DateTime.parse(item['zoneTask']['remainder']);
        else task.remainder = null;
        if(item['completeDate'] != null) task.completeDate = DateTime.parse(item['completeDate']);
        else task.completeDate = null;
        task.projectId = item['zoneTask']['zoneId'] * -1;
        Provider.of<TasksProvider>(context, listen: false).addTask(task, false);
      }
    }
    Navigator.pushReplacementNamed(context, DaysList.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromOfflineDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
        ),
      ),
    );
  }
}
