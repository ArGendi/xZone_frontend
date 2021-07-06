import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/task.dart';

class TaskInfo extends StatefulWidget {
  final Task task;

  const TaskInfo({Key key, this.task}) : super(key: key);

  @override
  _TaskInfoState createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  IconData flag = Icons.outlined_flag;
  Color flagColor = buttonColor;

  getFlag(){
    if(widget.task.priority == 1){
      flag = Icons.flag;
      flagColor = priority1Color;
    }
    else if(widget.task.priority == 2) {
      flag = Icons.flag;
      flagColor = priority2Color;
    }
    else if(widget.task.priority == 3) {
      flag = Icons.flag;
      flagColor = lowPriority;
    }
    else if(widget.task.priority == 4) {
      flag = Icons.outlined_flag;
      flagColor = lowPriority;
    }
    else {
      flag = Icons.outlined_flag;
      flagColor = buttonColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = '';
    DateTime now = DateTime.now();
    if(widget.task.dueDate.day == now.day) date = 'Today';
    else if(widget.task.dueDate.day == now.day+1) date = 'Tomorrow';
    else date = widget.task.dueDate.toString();
    getFlag();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.task.name,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                ),
              ),
              Icon(
                flag,
                color: flagColor,
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text(
            date,
            style: TextStyle(
              color: whiteColor,
              fontFamily: 'Montserrat-Light'
            ),
          ),
        ],
      ),
    );
  }
}
