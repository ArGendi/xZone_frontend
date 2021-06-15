import 'package:flutter/material.dart';

import '../constants.dart';

class TasksDay extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onclick;
  final List<Color> gColor;

  const TasksDay({Key key, this.text, this.icon, this.onclick, this.gColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          gradient: LinearGradient(
            colors: gColor
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: whiteColor,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
