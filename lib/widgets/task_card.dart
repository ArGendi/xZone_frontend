import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'add_task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Color bgColor;
  final int pIndex;
  final int sIndex;
  final Function cong;
  final bool fromZone;

  const TaskCard({Key key, @required this.task,@required this.bgColor, this.pIndex, this.sIndex, this.cong, this.fromZone = false}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  _completeTask() async{
    var response;
    if(!widget.fromZone) {
      response = await Provider.of<TasksProvider>(context, listen: false)
          .completeTask(widget.task);
      if (response != null) {
        var body = json.decode(response.body);
        List badges = body['badges'];
        if (badges.isNotEmpty) widget.cong();
      }
    }
    else{
      response = await Provider.of<TasksProvider>(context, listen: false)
          .completeZoneTask(widget.task);
    }
  }
  _deleteTask(){
    if(widget.task.projectId == 0)
      Provider.of<TasksProvider>(context, listen: false).removeTask(widget.task);
    else
      Provider.of<ProjectsProvider>(context, listen: false)
          .removeTaskFromSection(widget.pIndex, widget.sIndex, widget.task);
  }
  _editTask(Task task){
    Provider.of<TasksProvider>(context, listen: false).assignActiveTask(widget.task);
    if(widget.task.projectId == 0)
      Provider.of<TasksProvider>(context, listen: false).removeTask(widget.task);
    else
      Provider.of<ProjectsProvider>(context, listen: false)
          .removeTaskFromSection(widget.pIndex, widget.sIndex, widget.task);
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
                    onPressed: _completeTask,
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
