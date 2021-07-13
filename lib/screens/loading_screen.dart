import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/screens/days_list.dart';
import '../constants.dart';

class LoadingScreen extends StatefulWidget {
  static final String id = 'loading';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  DBHelper _dbHelper = DBHelper();

  _getDataFromOfflineDB() async{
    List<Task> projectTasks = await Provider.of<TasksProvider>(context, listen: false)
        .fetchAndSetData();
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
