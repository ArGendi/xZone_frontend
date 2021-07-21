import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/section.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';

import '../constants.dart';

class ProjectsProvider extends ChangeNotifier{
  List<Project> _items = [];
  DBHelper _dbHelper = DBHelper();
  var webServices = new WebServices();

  List get items {
    return _items;
  }

  Future<void> fetchAndSetData() async{
    var projectsData = await _dbHelper.getData(projectsTable);
    ///Projects
    for(Map item in projectsData){
      Project project = new Project(item['name']);
      project.id = item['id'];
      project.userID = item['userId'];
      var sectionsData = await _dbHelper.getSectionsOfProject(project.id);
      ///Sections
      for(Map sectionItem in sectionsData){
        Section section = new Section(sectionItem['name']);
        section.id = sectionItem['id'];
        section.parentProjectID = sectionItem['projectId'];
        var tasksData = await _dbHelper.getTasksOfSection(section.id, project.id);
        ///Tasks
        for(Map taskItem in tasksData){
          Task task = new Task();
          task.id = taskItem['id'];
          task.userId = taskItem['userId'];
          task.parentId = taskItem['parentId'];
          task.name = taskItem['name'];
          task.dueDate = DateTime.parse(taskItem['dueDate']);
          task.priority = taskItem['priority'];
          task.projectId = taskItem['projectId'];
          task.sectionId = taskItem['sectionId'];
          section.tasks.add(task);
        }
        project.sections.add(section);
      }
      _items.add(project);
    }
  }

  addProject(Project project, bool sendToBackend) async{
    _items.add(project);
    notifyListeners();
    if(sendToBackend){
      int userId = await HelpFunction.getUserId();
      project.userID = userId;
      http.Response response = await addProjectToBackend(project);
      if(response.statusCode == 200){
        var body = json.decode(response.body);
        project.id = body['id'];
        print('project added to backend');
      }
    }
    _dbHelper.insert(projectsTable,{
      'id': project.id,
      'userId': project.userID,
      'name': project.name,
    });
    print('Project added');
  }

  Future<http.Response> addProjectToBackend(Project project) async{
    var response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/project',
        {
          'name': project.name,
          'ownerID': project.userID,
        });
    return response;
  }

  addTaskToSection(int pIndex, int sIndex, Task task, bool sendToBackend) async{
    _items[pIndex].sections[sIndex].tasks.add(task);
    task.sectionId = _items[pIndex].sections[sIndex].id;
    notifyListeners();
    if(sendToBackend){
      http.Response response = await addProjectTaskToBackend(task);
      if(response.statusCode == 200){
        var body = json.decode(response.body);
        task.id = body['id'];
        print('Project Task added to backend');
      }
    }
    _dbHelper.insert(tasksTable,{
      'id': task.id,
      'userId': task.id,
      'parentId': task.parentId,
      'name': task.name,
      'dueDate': task.dueDate.toString(),
      'remainder': 'Empty',
      'completeDate': 'Empty',
      'priority': task.priority,
      'sectionId': _items[pIndex].sections[sIndex].id,
      'projectId': _items[pIndex].id,
    });
    print('Task added to section');
  }

  Future<http.Response> addProjectTaskToBackend(Task task) async{
    var response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/ProjectTask',
        {
          "name": task.name,
          "sectionId": task.sectionId,
          "priority": task.priority,
          "dueDate": task.dueDate != null ? task.dueDate.toString() : null,
          "remainder": task.remainder != null ? task.remainder.toString() : null,
          "completeDate": task.completeDate != null ? task.completeDate.toString() : null
        });
    return response;
  }

  removeTaskFromSection(int pIndex, int sIndex, Task task) async{
    _items[pIndex].sections[sIndex].tasks.remove(task);
    notifyListeners();
    _dbHelper.deleteRow(tasksTable, task.id);
    var response = await webServices.delete('http://xzoneapi.azurewebsites.net/api/v1/ProjectTask/${task.id}');
    if(response.statusCode >= 200 && response.statusCode < 300)
      print('Project Task deleted from backend');
  }

  addSection(int pIndex, Section section, bool sendToBackend) async{
    section.parentProjectID =  _items[pIndex].id;
    _items[pIndex].sections.add(section);
    notifyListeners();
    if(sendToBackend){
      http.Response response = await addSectionToBackend(section);
      if(response.statusCode == 200){
        var body = json.decode(response.body);
        section.id = body['id'];
        print('section added to backend');
      }
    }
    _dbHelper.insert(sectionsTable,{
      'id': section.id,
      'name': section.name,
      'projectId': _items[pIndex].id,
    });
    print('section added');
  }

  Future<http.Response> addSectionToBackend(Section section) async{
    var response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/Section',
        {
          'name': section.name,
          'parentProjectID': section.parentProjectID,
        });

    return response;
  }

  editProjectName(int pIndex, String newName) async{
    int projectId = _items[pIndex].id;
    _items[pIndex].name = newName;
    notifyListeners();
    _dbHelper.updateRow(projectsTable, _items[pIndex].id, {
      'userId': 0,
      'name': newName,
    });
    int userId = await HelpFunction.getUserId();
    var response = await webServices.update('http://xzoneapi.azurewebsites.net/api/v1/project/$projectId',{
      'name': newName,
      'ownerID': userId
    });
    if(response.statusCode == 200)
      print('Project updated in backend');
  }
  removeProject(int pIndex) async{
    int projectId = _items[pIndex].id;
    _items.removeAt(pIndex);
    notifyListeners();
    await _dbHelper.deleteRow(projectsTable, projectId);
    await _dbHelper.deleteAllRowsRelatedToProject(sectionsTable, projectId);
    await _dbHelper.deleteAllRowsRelatedToProject(tasksTable, projectId);
    var response = await webServices.delete('http://xzoneapi.azurewebsites.net/api/v1/project/$projectId');
    if(response.statusCode >= 200 && response.statusCode < 300)
      print('Project deleted from backend');
  }
  editSection(int pIndex, int sIndex, String newName) async{
    int projectId = _items[pIndex].id;
    int sectionId = _items[pIndex].sections[sIndex].id;
    _items[pIndex].sections[sIndex].name = newName;
    notifyListeners();
    _dbHelper.updateRow(sectionsTable, _items[pIndex].sections[sIndex].id, {
      'name': newName,
      'projectId': _items[pIndex].id,
    });
    var response = await webServices.update('http://xzoneapi.azurewebsites.net/api/v1/Section/$sectionId',{
      'name': newName,
      'parentProjectID': projectId
    });
    if(response.statusCode == 200)
      print('Section updated in backend');
  }
  removeSection(int pIndex, int sIndex) async{
    int sectionID = _items[pIndex].sections[sIndex].id;
    _items[pIndex].sections.removeAt(sIndex);
    notifyListeners();
    await _dbHelper.deleteRow(sectionsTable, sectionID);
    await _dbHelper.deleteAllRowsRelatedToSection(tasksTable, sectionID);
    var response = await webServices.delete('http://xzoneapi.azurewebsites.net/api/v1/Section/$sectionID');
    if(response.statusCode >= 200 && response.statusCode < 300)
      print('section deleted from backend');
  }

  completeTask(int pIndex, int sIndex, Task task) async{
    _items[pIndex].sections[sIndex].tasks.remove(task);
    notifyListeners();
    _dbHelper.deleteRow(tasksTable, task.id);
    int userId = await HelpFunction.getUserId();
    var response = await webServices.post('http://xzoneapi.azurewebsites.net/api/v1/task/${task.id}/$userId', {});
    if(response.statusCode == 200){
      print('Task Confirmed at Backend');
    }
  }

  addProjectDescription(int pIndex, String description){
    _items[pIndex].description = description;
    notifyListeners();
  }

}