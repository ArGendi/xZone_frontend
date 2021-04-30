import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/widgets/tasks_day.dart';

class DaysList extends StatelessWidget {
  static final String id = 'days list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: buttonColor,
              ),
              onPressed: (){}
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TasksDay(
              text: 'Today',
              icon: Icons.wb_sunny,
              onclick: (){
                Navigator.pushNamed(context, Tasks.id, arguments: {
                  'day': 'Today',
                  'date': DateTime.now(),
                });
              },
            ),
            Divider(
              color: greyColor,
              height: 20,
            ),
            TasksDay(
              text: 'Tomorrow',
              icon: Icons.calendar_today,
              onclick: (){
                var now = DateTime.now();
                var tomDate = DateTime(now.year, now.month, now.day + 1);
                Navigator.pushNamed(context, Tasks.id, arguments: {
                  'day': 'Tomorrow',
                  'date': tomDate,
                });
              },
            ),
            Divider(
              color: greyColor,
              height: 20,
            ),
            TasksDay(
              text: 'Future',
              icon: Icons.fact_check,
            ),
            Divider(
              color: greyColor,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
