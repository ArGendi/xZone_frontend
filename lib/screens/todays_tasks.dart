import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/today_tasks_provider.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/widgets/task_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayTasks extends StatefulWidget {
  static final String id = 'today tasks';
  @override
  _TodayTasksState createState() => _TodayTasksState();
}

class _TodayTasksState extends State<TodayTasks> {
  String date = DateFormat('EEEE, d MMM').format(DateTime.now());

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

  @override
  Widget build(BuildContext context) {
//    var now = DateTime.now();
//    var activeTaskDate = Provider.of<TasksProvider>(context).activeTask.date;
//    if(activeTaskDate == null)
//      Provider.of<TasksProvider>(context).setActiveTaskDate(now);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/manuel-will-gd3t5Dtbwkw-unsplash.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
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
                          onPressed: () {},
                          icon: Icon(Icons.arrow_back_ios),
                          color: buttonColor,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.sort),
                          color: buttonColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 32,
                            color: whiteColor,
                            fontFamily: 'Montserrat-Medium'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          List<Task> items = Provider.of<TasksProvider>(context).items;
                          if(items.length == 0){
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
                                          fontFamily: 'Montserrat-Medium',
                                          color: whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          else return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index){
                              return TaskCard(task: items[index],);
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
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: addTaskBottomSheet,
          child: Icon(Icons.add),
          backgroundColor: buttonColor,
        ),
      ),
    );
  }
}
