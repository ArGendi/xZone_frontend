import 'package:flutter/cupertino.dart';
import 'package:xzone/models/task.dart';

class TasksProvider extends ChangeNotifier{
  Task _activeTask = Task();
  List<Task> _items = List<Task>();

  TasksProvider(){
    _activeTask.name = '';
  }
  List get items {
    return _items;
  }
  Task get activeTask{
    return _activeTask;
  }
  void addTask(Task task){
    _items.add(task);
    notifyListeners();
  }
  void removeTask(Task task){
    _items.remove(task);
    notifyListeners();
  }
  void setActiveTaskName(String name){
    _activeTask.name = name;
    notifyListeners();
  }

}