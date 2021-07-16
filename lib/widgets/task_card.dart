import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/tasks_provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'add_task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Color bgColor;

  const TaskCard({Key key, @required this.task,@required this.bgColor}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  _completeTask(BuildContext ctx){
    Provider.of<TasksProvider>(ctx, listen: false).moveTaskToRecentlyDeleted(widget.task);
  }
  _deleteTask(){
    Provider.of<TasksProvider>(context, listen: false).removeTask(widget.task);
  }
  _editTask(Task task){
    Provider.of<TasksProvider>(context, listen: false).assignActiveTask(widget.task);
    Provider.of<TasksProvider>(context, listen: false).removeTask(widget.task);
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
  _showSnackBar(BuildContext ctx){
    _completeTask(ctx);
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      //width: MediaQuery.of(context).size.width * 0.6,
      //behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 6),
      backgroundColor: backgroundColor,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Yaaah!! , You complete the task',
          style: TextStyle(
              fontSize: 15
          ),
        ),
      ),
      action: SnackBarAction(
        label: 'Undo',
        textColor: buttonColor,
        onPressed: (){
          Provider.of<TasksProvider>(ctx, listen: false).returnBackDeletedTaskToItems();
        },
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Card(
        elevation: 0,
        color: widget.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext ctx) {
                  return IconButton(
                    iconSize: 20,
                    onPressed: (){},
                    icon: Icon(
                      Icons.panorama_fish_eye,
                      color: whiteColor,
                    ),
                  );
                },
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
