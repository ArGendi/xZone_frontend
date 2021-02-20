import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xzone/providers/today_tasks_provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

class ChooseDate extends StatefulWidget {
  @override
  _ChooseDateState createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  calendarBottomSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String today = DateFormat('EEE').format(now);
    var tomFullDate = DateTime(now.year, now.month, now.day + 1);
    var nextWeekFullDate = DateTime(now.year, now.month, now.day + 7);
    String tom = DateFormat('EEE').format(tomFullDate);
    String nextWeek = DateFormat('EEE').format(nextWeekFullDate);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: (){
                  Provider.of<TasksProvider>(context, listen: false).setActiveTaskDate(now);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat-Medium',
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        today,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat-Medium',
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Provider.of<TasksProvider>(context, listen: false).setActiveTaskDate(tomFullDate);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Tomorrow',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat-Medium',
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        tom,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat-Medium',
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  print(nextWeekFullDate);
                  Provider.of<TasksProvider>(context, listen: false).setActiveTaskDate(nextWeekFullDate);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Next Week',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat-Medium',
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        nextWeek,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat-Medium',
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: calendarBottomSheet,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat-Medium',
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: whiteColor,
                      ),
                    ],
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
