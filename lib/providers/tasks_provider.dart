import 'package:flutter/cupertino.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/task.dart';

class TasksProvider extends ChangeNotifier {
  Task _activeTask = Task();
  Task _recentDeletedTask = Task();
  List<Task> _items = [];
  String _sortType = 'by Due Date';
  DBHelper _dbHelper = DBHelper();

  List get items {
    return _items;
  }

  Task get activeTask {
    return _activeTask;
  }

  Task get recentDeletedTask {
    return _recentDeletedTask;
  }

  String get sortType {
    return _sortType;
  }

  Future<List<Task>> fetchAndSetData() async{
    var tasksData = await _dbHelper.getData(tasksTable);
    List<Task> projectTasks = [];
    for(Map item in tasksData){
      Task task = new Task();
      task.id = item['id'];
      task.userId = item['userId'];
      task.parentId = item['parentId'];
      task.name = item['name'];
      task.dueDate = DateTime.parse(item['dueDate']);
      task.priority = item['priority'];
      if(item['projectId'] == 0){
        task.projectId = task.sectionId = 0;
        _items.add(task);
      }
      else{
        task.projectId = item['projectId'];
        task.sectionId = item['sectionId'];
        projectTasks.add(task);
      }
    }
    return projectTasks;
  }

  void addTask(Task task) {
    _items.add(task);
    notifyListeners();
    _dbHelper.insert(tasksTable,{
      'id': task.id,
      'userId': 0,
      'parentId': 0,
      'name': task.name,
      'dueDate': task.dueDate.toString(),
      'remainder': 'Empty',
      'completeDate': 'Empty',
      'priority': task.priority,
      'sectionId': 0,
      'projectId': 0,
    });
    print('Task added');
  }

  void removeTask(Task task) {
    _items.remove(task);
    notifyListeners();
    _dbHelper.deleteRow(tasksTable, task.id);
  }

  void setActiveTaskName(String name) {
    _activeTask.name = name;
    notifyListeners();
  }

  void setActiveTaskDueDate(DateTime date) {
    _activeTask.dueDate = date;
    notifyListeners();
  }

  void setActiveTaskRemainder(DateTime date) {
    _activeTask.remainder = date;
    notifyListeners();
  }

  void setActiveTaskPriority(int priority) {
    _activeTask.priority = priority;
    notifyListeners();
  }

  void setActiveTaskCompleteDate(DateTime date) {
    _activeTask.completeDate = date;
    notifyListeners();
  }

  void setActiveTaskId(int id) {
    _activeTask.id = id;
    notifyListeners();
  }

  void setActiveTaskUserId(int id) {
    _activeTask.userId = id;
    notifyListeners();
  }

  void initializeActiveTask() {
    _activeTask = new Task();
    notifyListeners();
  }

  void assignActiveTask(Task task) {
    _activeTask = task;
    notifyListeners();
  }

  void sortByDate() {
    _items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  void sortByPriority() {
    _items.sort((a, b) => a.priority.compareTo(b.priority));
    notifyListeners();
  }

  void setSortType(String selectedType) {
    _sortType = selectedType;
    notifyListeners();
  }

  void moveTaskToRecentlyDeleted(Task task) {
    _recentDeletedTask = task;
    _items.remove(task);
    notifyListeners();
  }

  void returnBackDeletedTaskToItems() {
    _items.add(_recentDeletedTask);
    _recentDeletedTask = Task();
    notifyListeners();
  }
}
