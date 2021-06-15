import 'package:flutter/cupertino.dart';
import 'package:xzone/models/task.dart';

class TasksProvider extends ChangeNotifier{
  Task _activeTask = Task();
  Task _recentDeletedTask = Task();
  List<Task> _items = [];
  String _sortType = 'by Due Date';

  List get items {
    return _items;
  }
  Task get activeTask{
    return _activeTask;
  }
  Task get recentDeletedTask{
    return _recentDeletedTask;
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
  void setActiveTaskDueDate(DateTime date){
    _activeTask.dueDate = date;
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
    _items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
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
  void moveTaskToRecentlyDeleted(Task task){
    _recentDeletedTask = task;
    _items.remove(task);
    notifyListeners();
  }
  void returnBackDeletedTaskToItems(){
    _items.add(_recentDeletedTask);
    _recentDeletedTask = Task();
    notifyListeners();
  }

}