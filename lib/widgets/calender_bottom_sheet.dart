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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
}
