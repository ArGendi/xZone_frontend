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

class Tasks extends StatefulWidget {
  static final String id = 'today tasks';
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
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
  sortTasksBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return ChooseSortType();
        });
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: sortTasksBottomSheet,
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          color: whiteColor,
                          fontFamily: 'Montserrat-Light'
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
                          List<Task> filteredItems = items.where(
                                  (element) => element.date.day == DateTime.now().day
                          ).toList();
                          if(filteredItems.length == 0){
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
                          }
                          else return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index){
                              return TaskCard(task: filteredItems[index],);
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
