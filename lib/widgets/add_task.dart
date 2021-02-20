import 'package:flutter/material.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/today_tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:xzone/widgets/choose_date.dart';
import 'package:xzone/widgets/choose_priority.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {

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
  setDateBottomSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return ChooseDate();
        });
  }

  @override
  Widget build(BuildContext context) {
    IconData flag = Icons.outlined_flag;
    Color flagColor = buttonColor;
    Task activeTask = Provider.of<TasksProvider>(context).activeTask;
    var now = DateTime.now();
    String selectedDate;

    if(firstTime) textfieldController.text = activeTask.name;
    textfieldController.selection = TextSelection.fromPosition(TextPosition(offset: textfieldController.text.length));

    //Priority
    if(activeTask.priority == 1){
      flag = Icons.flag;
      flagColor = priority1Color;
    }
    else if(activeTask.priority == 2) {
      flag = Icons.flag;
      flagColor = priority2Color;
    }
    else if(activeTask.priority == 3) {
      flag = Icons.flag;
      flagColor = lowPriority;
    }
    else if(activeTask.priority == 4)
      flagColor = lowPriority;

    //Date
    if(activeTask.date.day == now.day) selectedDate = 'Today';
    else if(activeTask.date.day == now.day + 1) selectedDate = 'Tomorrow';
    else selectedDate = DateFormat('d MMM').format(activeTask.date);

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
                        flag,
                        color: flagColor,
                      ),
                    ),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: setDateBottomSheet,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              color: buttonColor,
                            ),
                            SizedBox(width: 8,),
                            Text(
                              selectedDate,
                              style: TextStyle(
                                color: buttonColor,
                                fontFamily: 'Montserrat-Medium',
                              ),
                            ),
                          ],
                        ),
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
                    String temp = activeTask.name[0].toUpperCase() + activeTask.name.substring(1, activeTask.name.length);
                    Provider.of<TasksProvider>(context, listen: false).setActiveTaskName(temp);
                    Provider.of<TasksProvider>(context, listen: false)
                        .addTask(activeTask);
                    Provider.of<TasksProvider>(context, listen: false)
                        .initializeActiveTask();
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
