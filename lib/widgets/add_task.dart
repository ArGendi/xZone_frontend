import 'package:flutter/material.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/today_tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:xzone/widgets/choose_priority.dart';
import '../constants.dart';

class AddTask extends StatefulWidget {
  final BuildContext ctx;

  const AddTask({Key key, this.ctx}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool firstTime = true;
  var textfieldController = TextEditingController();

  setPriorityBottomSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return ChoosePriority();
        });
  }


  @override
  Widget build(BuildContext context) {
    Task activeTask = Provider.of<TasksProvider>(context).activeTask;
    if(firstTime) textfieldController.text = activeTask.name;
    textfieldController.selection = TextSelection.fromPosition(TextPosition(offset: textfieldController.text.length));

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: textfieldController,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat-Medium',
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: backgroundColor,
                    hintText: 'e.g. Drink water',
                    hintStyle: TextStyle(
                        color: greyColor,
                        fontFamily: 'Montserrat-Medium'
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: (value){
                    firstTime = false;
                    Provider.of<TasksProvider>(context, listen: false).setActiveTaskName(value);
                  },
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: setPriorityBottomSheet,
                      icon: Icon(
                        Icons.flag,
                        color: buttonColor,
                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(
                        Icons.calendar_today,
                        color: buttonColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: IconButton(
                iconSize: 30,
                onPressed: (){
                  if(activeTask.name.length > 1) {
                    Task newTask = Task();
                    newTask.name = activeTask.name[0].toUpperCase() + activeTask.name.substring(1, activeTask.name.length);
                    Provider.of<TasksProvider>(widget.ctx, listen: false)
                        .addTask(newTask);
                    Provider.of<TasksProvider>(context, listen: false)
                        .setActiveTaskName('');
                    textfieldController.clear();
                  }
                },
                icon: Icon(
                  Icons.add_circle,
                  color: buttonColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
