import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/widgets/custom_calendar.dart';

import '../constants.dart';

class CalenderBottomSheet extends StatelessWidget {
  final String btnText;
  final Function onClick;
  final DateTime initialSelectedDay;
  final Function onDaySelected;

  const CalenderBottomSheet({Key key, this.btnText, this.onClick, this.initialSelectedDay, this.onDaySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: onClick,
                    child: Text(
                      btnText,
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              CustomCalender(
                initialSelectedDay: initialSelectedDay,
                onDaySelected: onDaySelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
