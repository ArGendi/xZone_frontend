import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import '../constants.dart';

class SortType extends StatelessWidget {
  static const double fontSize = 16;
  final String text;
  final Function sortBy;
  final IconData icon;

  const SortType({Key key, this.text, this.sortBy, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedSortType =  Provider.of<TasksProvider>(context).sortType;

    return InkWell(
      onTap: (){
        sortBy();
        Provider.of<TasksProvider>(context, listen: false).setSortType(text);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: whiteColor,
            ),
            SizedBox(width: 15,),
            Text(
              text,
              style: TextStyle(
                color: whiteColor,
                fontSize: fontSize,
              ),
            ),
            SizedBox(width: 5,),
            if(selectedSortType == text)
              Icon(
                Icons.check,
                color: whiteColor,
              )
          ],
        ),
      ),
    );
  }
}

