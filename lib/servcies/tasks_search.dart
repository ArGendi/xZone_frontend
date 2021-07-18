import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/widgets/task_info.dart';
import '../constants.dart';

class TasksSearch extends SearchDelegate{
  List<Task> filteredTasks = [];

  showTaskInfoDialog(context, task){
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content: TaskInfo(task: task,),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextButton(
                  onPressed: (){
                    Provider.of<TasksProvider>(context, listen: false).moveTaskToRecentlyDeleted(task);
                    Provider.of<TasksProvider>(context, listen: false).removeTask(task);
                    Navigator.pop(context);
                    query = '';
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.red,
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextButton(
                  onPressed: (){
                    Provider.of<TasksProvider>(context, listen: false).removeTask(task);
                    Navigator.pop(context);
                    query = '';
                  },
                  child: Text(
                    'Complete',
                    style: TextStyle(
                        color: buttonColor
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                        color: buttonColor
                    ),
                  )
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: backgroundColor,
        ),
        onPressed: (){
          query = '';
        },
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        color: backgroundColor,
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> tasks = Provider.of<TasksProvider>(context).items;
    filteredTasks = tasks.where((element) => element.name.toLowerCase().contains(query)).toList();
    if (query.isNotEmpty) return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index){
          return InkWell(
            onTap: (){
              showTaskInfoDialog(context, filteredTasks[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          filteredTasks[index].name,
                          style: TextStyle(
                            fontSize: 16,
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: whiteColor,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    else return Container();
    throw UnimplementedError();
  }

}