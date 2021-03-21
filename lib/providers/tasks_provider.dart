import 'package:flutter/cupertino.dart';
import 'package:xzone/models/task.dart';

class TasksProvider extends ChangeNotifier{
  Task _activeTask = Task();
  List<Task> _items = List<Task>();
  String _sortType = 'by Date';

  List get items {
    return _items;
  }
  Task get activeTask{
    return _activeTask;
  }
  String get sortType{
    return _sortType;
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
  void setActiveTaskDate(DateTime date){
    _activeTask.date = date;
    notifyListeners();
  }
  void setActiveTaskRemainder(DateTime date){
    _activeTask.remainder = date;
    notifyListeners();
  }
  void setActiveTaskPriority(int priority){
    _activeTask.priority = priority;
    notifyListeners();
  }
  void setActiveTaskCompleteDate(DateTime date){
    _activeTask.completeDate = date;
    notifyListeners();
  }
  void setActiveTaskId(int id){
    _activeTask.id = id;
    notifyListeners();
  }
  void setActiveTaskUserId(int id){
    _activeTask.userId = id;
    notifyListeners();
  }
  void initializeActiveTask(){
    _activeTask = new Task();
    notifyListeners();
  }
  void assignActiveTask(Task task){
    _activeTask = task;
    notifyListeners();
  }
  void sortByDate(){
    _items.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }
  void sortByPriority(){
    _items.sort((a, b) => a.priority.compareTo(b.priority));
    notifyListeners();
  }
  void setSortType(String selectedType){
    _sortType = selectedType;
    notifyListeners();
  }

}