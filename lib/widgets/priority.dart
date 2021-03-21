import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import '../constants.dart';

class Priority extends StatelessWidget {
  final int number;
  final String text;
  final IconData icon;
  final Color flagColor;

  const Priority({Key key, this.number, this.text, this.flagColor, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int chosenPriority = Provider.of<TasksProvider>(context).activeTask.priority;
    return InkWell(
      onTap: (){
        Provider.of<TasksProvider>(context, listen: false).setActiveTaskPriority(number);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: flagColor,
            ),
            SizedBox(width: 10,),
            Text(
              text,
              style: TextStyle(
                color: whiteColor,
                fontSize: 16,
                fontFamily: 'Montserrat-Medium',
              ),
            ),
            SizedBox(width: 10,),
            if(chosenPriority == number)
              Icon(
                Icons.check,
                color: whiteColor,
              ),
          ],
        ),
      ),
    );
  }
}
