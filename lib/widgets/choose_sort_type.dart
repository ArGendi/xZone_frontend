import 'package:flutter/material.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:xzone/widgets/sort_type.dart';
import '../constants.dart';

class ChooseSortType extends StatefulWidget {
  @override
  _ChooseSortTypeState createState() => _ChooseSortTypeState();
}

class _ChooseSortTypeState extends State<ChooseSortType> {

  void sortByDate(){
    Provider.of<TasksProvider>(context, listen: false).sortByDate();
  }
  void sortByPriority(){
    Provider.of<TasksProvider>(context, listen: false).sortByPriority();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SortType(
            text: 'by Due Date',
            sortBy: sortByDate,
            icon: Icons.date_range,
          ),
          SizedBox(height: 5,),
          SortType(
            text: 'by Priority',
            sortBy: sortByPriority,
            icon: Icons.flag,
          ),
        ],
      ),
    );
  }
}
