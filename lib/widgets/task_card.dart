import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/today_tasks_provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

import 'add_task.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({Key key, this.task}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isChecked = false;

  _deleteTask(){
    Provider.of<TasksProvider>(context, listen: false).removeTask(widget.task);
  }
  _editTask(Task task){
    Provider.of<TasksProvider>(context, listen: false).setActiveTaskName(widget.task.name);
    Provider.of<TasksProvider>(context, listen: false).removeTask(widget.task);
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context) {
          return AddTask(
            ctx: context,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Card(
        elevation: 0,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: <Widget>[
              IconButton(
                iconSize: 20,
                onPressed: (){
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                icon: Icon(
                  !isChecked ? Icons.panorama_fish_eye : Icons.check_circle,
                  color: whiteColor,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.task.name,
                    style: TextStyle(
                      color: whiteColor,
                      fontFamily: 'Montserrat-Medium',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadiusValue),
              bottomLeft: Radius.circular(borderRadiusValue),
            ),
            child: IconSlideAction(
              color: backgroundColor,
              icon: Icons.edit,
              onTap: (){
                _editTask(widget.task);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(borderRadiusValue),
              bottomRight: Radius.circular(borderRadiusValue),
            ),
            child: IconSlideAction(
              color: Colors.red,
              icon: Icons.delete_outline,
              onTap: _deleteTask,
            ),
          ),
        ),
      ],
    );
  }
}
