import 'package:flutter/material.dart';

import '../constants.dart';

class ChooseTime extends StatefulWidget {
  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(),
        ),
      ),
    );
  }
}
