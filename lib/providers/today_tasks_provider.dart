import 'package:flutter/cupertino.dart';
import 'package:xzone/models/task.dart';

class TasksProvider extends ChangeNotifier{
  List<Task> items = List<Task>();

  void addTask(Task task){
    items.add(task);
    notifyListeners();
  }

  void removeTask(Task task){
    items.remove(task);
    notifyListeners();
  }
}