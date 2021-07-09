import 'package:flutter/material.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:xzone/widgets/calender_bottom_sheet.dart';
import 'package:xzone/widgets/choose_date.dart';
import 'package:xzone/widgets/choose_priority.dart';
import 'package:xzone/widgets/choose_time.dart';
import 'package:xzone/widgets/custom_calendar.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  static final String id = 'add task';
  final bool inSection;
  final int pIndex;
  final int sIndex;

  const AddTask({Key key, this.inSection = false, this.pIndex, this.sIndex}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool firstTime = true;
  var textfieldController = TextEditingController();
  IconData flag = Icons.outlined_flag;
  Color flagColor = buttonColor;
  var now = DateTime.now();
  String selectedDate;

  setTimeBottomSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return ChooseTime();
        });
  }
  setPriorityBottomSheet(){
    FocusScope.of(context).unfocus();
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
    FocusScope.of(context).unfocus();
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
  setRemainderBottomSheet(){
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          DateTime remainder = Provider.of<TasksProvider>(context).activeTask.remainder;
          return CalenderBottomSheet(
            btnText: 'Next',
            onClick: (){
              Navigator.pop(context);
              setTimeBottomSheet();
            },
            initialSelectedDay: Provider.of<TasksProvider>(context).activeTask.remainder,
            onDaySelected: (date, event, _){
              if(date != remainder)
                Provider.of<TasksProvider>(context, listen: false).setActiveTaskRemainder(date);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Task activeTask = Provider.of<TasksProvider>(context).activeTask;

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
    else {
      flag = Icons.outlined_flag;
      flagColor = buttonColor;
    }

    //Date
    if(activeTask.dueDate.day == now.day) selectedDate = 'Today';
    else if(activeTask.dueDate.day == now.day + 1) selectedDate = 'Tomorrow';
    else selectedDate = DateFormat('d MMM').format(activeTask.dueDate);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            autofocus: true,
            cursorColor: Colors.white,
            controller: textfieldController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              fillColor: backgroundColor,
              hintText: 'e.g. Drink water',
              hintStyle: TextStyle(
                  color: greyColor,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  IconButton(
                      icon: Icon(
                        Icons.alarm_off,
                        color: buttonColor,
                      ),
                      onPressed: setRemainderBottomSheet
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  iconSize: 28,
                  onPressed: (){
                    if(activeTask.name.length > 1) {
                      DateTime date = activeTask.dueDate;
                      String temp = activeTask.name[0].toUpperCase() + activeTask.name.substring(1, activeTask.name.length);
                      Provider.of<TasksProvider>(context, listen: false).setActiveTaskName(temp);
                      if(widget.inSection)
                        Provider.of<ProjectsProvider>(context, listen: false)
                            .addTaskToSection(widget.pIndex, widget.sIndex, activeTask);
                      else
                        Provider.of<TasksProvider>(context, listen: false)
                          .addTask(activeTask);
                      Provider.of<TasksProvider>(context, listen: false)
                          .initializeActiveTask();
                      Provider.of<TasksProvider>(context, listen: false).setActiveTaskDueDate(date);
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
        ],
      ),
    );
  }
}
