import 'package:flutter/material.dart';

import '../constants.dart';

class TaskCard extends StatefulWidget {
  final String text;

  const TaskCard({Key key, this.text}) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: Row(
          children: <Widget>[
            IconButton(
              iconSize: 20,
              onPressed: (){
                setState(() {
                  isChecked = !isChecked;
                });
              },
              icon: Icon(
                !isChecked ? Icons.panorama_fish_eye : Icons.check_circle,
                color: whiteColor,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.text,
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
    );
  }
}
