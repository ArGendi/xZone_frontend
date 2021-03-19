import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalender extends StatefulWidget {
  @override
  _CustomCalenderState createState() => _CustomCalenderState();
}

class _CustomCalenderState extends State<CustomCalender> {
  CalendarController _calendarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TableCalendar(
            calendarController: _calendarController,
            availableGestures: AvailableGestures.horizontalSwipe,
            calendarStyle: CalendarStyle(
              weekdayStyle: TextStyle(
                color: whiteColor
              ),
              weekendStyle: TextStyle(
                  color: buttonColor
              ),
              selectedColor: buttonColor,
              todayColor: greyColor,
              outsideStyle: TextStyle(
                  color: greyColor,
              ),
              outsideWeekendStyle: TextStyle(
                color: greyColor,
              ),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(
                color: whiteColor,
              ),
              formatButtonTextStyle: TextStyle(
                color: whiteColor,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: whiteColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: whiteColor,
              ),
              formatButtonVisible: false,
              centerHeaderTitle: true,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: whiteColor,
              ),
              weekendStyle: TextStyle(
                  color: buttonColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}
