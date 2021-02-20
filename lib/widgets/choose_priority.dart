import 'package:flutter/material.dart';
import 'package:xzone/providers/today_tasks_provider.dart';
import 'package:xzone/widgets/priority.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

class ChoosePriority extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Priority(
                text: 'Priority 1 \t (Highest)',
                number: 1,
                icon: Icons.flag,
                flagColor: priority1Color,
              ),
              Priority(
                text: 'Priority 2',
                number: 2,
                icon: Icons.flag,
                flagColor: priority2Color,
              ),
              Priority(
                text: 'Priority 3',
                number: 3,
                icon: Icons.flag,
                flagColor: lowPriority,
              ),
              Priority(
                text: 'Priority 4',
                number: 4,
                icon: Icons.outlined_flag,
                flagColor: lowPriority,
              ),
              Priority(
                text: 'No Priority',
                number: 0,
                icon: Icons.clear,
                flagColor: whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
