import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:http/http.dart' as http;

class TasksProvider extends ChangeNotifier {
  Task _activeTask = Task();
  Task _recentDeletedTask = Task();
  List<Task> _items = [];
  String _sortType = 'by Due Date';
  DBHelper _dbHelper = DBHelper();
  var webServices = new WebServices();

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

  Future<void> fetchAndSetData() async{
    var tasksData = await _dbHelper.getNormalTasks();
    for(Map item in tasksData){
      //if(item['completeDate'] != null) continue;
      Task task = new Task();
      task.id = item['id'];
      task.userId = item['userId'];
      task.parentId = item['parentId'];
      task.name = item['name'];
      task.dueDate = item['dueDate'] != null ? DateTime.parse(item['dueDate']) : null;
      if(item['remainder'] != 'Empty')
        task.remainder = DateTime.parse(item['remainder']);
      task.priority = item['priority'];
      task.projectId = item['projectId'];
      task.sectionId = item['sectionId'];
      _items.add(task);
    }
  }

  void addTask(Task task, bool sendToBackend) async{
    _items.add(task);
    notifyListeners();
    if(sendToBackend){
      int userId = await HelpFunction.getUserId();
      task.userId = userId;
      http.Response response = await addTaskToBackend(task);
      if(response.statusCode == 200){
        var body = json.decode(response.body);
        task.id = body['id'];
        print('task added to backend');
      }
    }
    _dbHelper.insert(tasksTable,{
      'id': task.id,
      'userId': task.userId,
      'parentId': task.parentId,
      'name': task.name,
      'dueDate': task.dueDate != null ? task.dueDate.toString() : null,
      'remainder': task.remainderOn ? task.remainder.toString() : 'Empty',
      'completeDate': task.completeDate != null ? task.completeDate.toString() : null,
      'priority': task.priority.toString(),
      'sectionId': 0,
      'projectId': 0,
    });
    print('Task added');
  }

  addZoneTask(Task task, int zoneId) async{
    _items.add(task);
    notifyListeners();
    int userId = await HelpFunction.getUserId();
    task.userId = userId;
    http.Response response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/Zonetask',
        {
          "name": task.name,
          "zoneId": zoneId,
        });
    if(response.statusCode == 200){
      var body = json.decode(response.body);
      task.id = body['id'];
      print('Zone task added to backend');
    }
    _dbHelper.insert(tasksTable,{
      'id': task.id,
      'userId': task.userId,
      'parentId': task.parentId,
      'name': task.name,
      'dueDate': task.dueDate != null ? task.dueDate.toString() : null,
      'remainder': task.remainderOn ? task.remainder.toString() : 'Empty',
      'completeDate': task.completeDate != null ? task.completeDate.toString() : null,
      'priority': task.priority.toString(),
      'sectionId': 0,
      'projectId': task.projectId,
    });
    print('Zone Task added');
  }

  completeZoneTask(Task task) async{
    _items.remove(task);
    notifyListeners();
    _dbHelper.deleteRow(tasksTable, task.id);
    int userId = await HelpFunction.getUserId();
    var response = await webServices.update('http://xzoneapi.azurewebsites.net/api/v1/AccountZoneTask', {
      "accountID": userId,
      "zoneTaskID": task.id,
    });
    if(response.statusCode == 200){
      print('Zone Task Confirmed at Backend');
      print(response.body);
      return response;
    }
    return null;
  }

  Future<http.Response> addTaskToBackend(Task task) async{
    var response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/task',
        {
          'name': task.name,
          'userID': task.userId,
          'priority': task.priority,
          'dueDate': task.dueDate != null ? task.dueDate.toString() : null,
          'remainder': task.remainder != null ? task.remainder.toString() : null,
          'completeDate': task.completeDate != null ? task.completeDate.toString() : null
        });
    return response;
  }

  void removeTask(Task task) async{
    _items.remove(task);
    notifyListeners();
    _dbHelper.deleteRow(tasksTable, task.id);
    var response = await webServices.delete('http://xzoneapi.azurewebsites.net/api/v1/task/${task.id}');
    if(response.statusCode >= 200 && response.statusCode < 300)
      print('Task deleted from backend');
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
  void turnOnActiveTaskRemainder(){
    _activeTask.remainderOn = true;
    notifyListeners();
  }

  Future<http.Response> completeTask(Task task) async{
    _items.remove(task);
    notifyListeners();
    _dbHelper.deleteRow(tasksTable, task.id);
    int userId = await HelpFunction.getUserId();
    var response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/task/${task.id}/$userId', {});
    if(response.statusCode == 200){
      print('Task Confirmed at Backend');
      print(response.body);
      return response;
    }
    return null;
  }

}
