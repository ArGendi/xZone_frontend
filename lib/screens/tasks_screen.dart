import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/widgets/choose_sort_type.dart';
import 'package:xzone/widgets/task_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xzone/repositories/DataBase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xzone/servcies/taskService.dart';

class Tasks extends StatefulWidget {
  static final String id = 'today tasks';

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Map data;
  bool pageUpdated = false;

  addTaskBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context) {
          return AddTask();
        });
  }

  sortTasksBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context) {
          return ChooseSortType();
        });
  }

  showCongratulationDialog(){
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/popper.png',
                width: 100,
              ),
              Text(
                'You have complete 2 tasks',
                style: TextStyle(
                  fontSize: 16,
                  color: whiteColor,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Great',
                    style: TextStyle(
                      color: buttonColor,
                    ),
                  )
              ),
            ),
          ],
        );
      },
    );
  }

  var _taskservice = Taskservice();
  var task = Task();
  String date;

  getTasks() async {
    var tasks = await _taskservice.readtasks();
    tasks.forEach((task) {
      var mytask = Task();
      mytask.id = task['id'];
      mytask.name = task['name'];
      mytask.userId = task['userid'];
      mytask.parentId = task['parentid'];
      mytask.priority = task['priority'];
      mytask.dueDate = DateTime.parse(task['dueDate']);
      Provider.of<TasksProvider>(context).addTask(mytask, true);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTasks();
  }

  Widget build(BuildContext context) {
    if (!pageUpdated) {
      data = ModalRoute.of(context).settings.arguments;
      pageUpdated = true;
    }
    if(data['date'] != null)
      date = DateFormat('EEEE, d MMM').format(data['date']);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/wallpaper.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                        color: buttonColor,
                      ),
                      IconButton(
                        onPressed: sortTasksBottomSheet,
                        icon: Icon(Icons.sort),
                        color: buttonColor,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      data['day'],
                      style: TextStyle(
                        fontSize: 32,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      data['day'] == 'Future' || data['day'] == 'Inbox' ? '' : date,
                      style: TextStyle(
                          fontSize: 18,
                          color: whiteColor,
                          fontFamily: 'Montserrat-Light'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        List<Task> items =
                            Provider.of<TasksProvider>(context).items;
                        List<Task> filteredItems;
                        if(data['day'] == 'Inbox'){
                          filteredItems = items
                              .where((element) =>
                          element.dueDate == null)
                              .toList();
                        }
                        else if (data['day'] != 'Future') {
                          filteredItems = items
                              .where((element) {
                                if(element.dueDate == null) return false;
                                else return element.dueDate.day == data['date'].day;
                              })
                              .toList();
                        }
                        else {
                          filteredItems = items
                              .where((element) {
                                if(element.dueDate == null) return false;
                                else return element.dueDate.day >= data['date'].day;
                              })
                              .toList();
                        }
                        if (filteredItems.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/emptyTasks.png',
                                      width: 300,
                                    ),
                                    Text(
                                      'Empty Tasks',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              return TaskCard(
                                bgColor: backgroundColor,
                                task: filteredItems[index],
                                cong: showCongratulationDialog,
                                //fromZone: filteredItems[index].projectId < 0 ? true : false,
                              );
                            },
                          );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Provider.of<TasksProvider>(context, listen: false)
                .setActiveTaskDueDate(data['date']);
            addTaskBottomSheet();
          },
          child: Icon(Icons.add),
          backgroundColor: buttonColor,
        ),
      ),
    );
  }
}
