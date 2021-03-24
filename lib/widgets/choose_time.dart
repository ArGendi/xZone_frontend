import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import '../constants.dart';

class ChooseTime extends StatefulWidget {
  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime activeTaskRemainder = Provider.of<TasksProvider>(context).activeTask.remainder;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: buttonColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Brightness.dark
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: _dateTime,
                    onDateTimeChanged: (newDate){
                      DateTime remainder = DateTime(
                        activeTaskRemainder.year,
                        activeTaskRemainder.month,
                        activeTaskRemainder.day,
                        newDate.hour,
                        newDate.minute,
                      );
                      Provider.of<TasksProvider>(context, listen: false).setActiveTaskRemainder(remainder);
                    },
                    mode: CupertinoDatePickerMode.time,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
