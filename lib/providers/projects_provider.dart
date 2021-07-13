import 'package:flutter/cupertino.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/section.dart';
import 'package:xzone/models/task.dart';

import '../constants.dart';

class ProjectsProvider extends ChangeNotifier{
  List<Project> _items = [];
  DBHelper _dbHelper = DBHelper();

  List get items {
    return _items;
  }

  Future<void> fetchAndSetData(List<Task> projectTasks) async{
    var sectionsData = await _dbHelper.getData(sectionsTable);
    var projectsData = await _dbHelper.getData(projectsTable);
    List<Section> sections = [];
    for(Map item in sectionsData){
      Section section = new Section(item['name']);
      section.id = item['id'];
    }
  }

  addProject(Project project){
    _items.add(project);
    notifyListeners();
    _dbHelper.insert(projectsTable,{
      'id': project.id,
      'userId': 0,
      'name': project.name,
    });
    print('Project added');
  }
  addTaskToSection(int pIndex, int sIndex, Task task){
    _items[pIndex].sections[sIndex].tasks.add(task);
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
      'sectionId': _items[pIndex].sections[sIndex].id,
      'projectId': _items[pIndex].id,
    });
    print('Task added to section');
  }
  addSection(int pIndex, Section section){
    _items[pIndex].sections.add(section);
    notifyListeners();
    _dbHelper.insert(sectionsTable,{
      'id': section.id,
      'name': section.name,
      'projectId': _items[pIndex].id,
    });
    print('section added');
  }
  editProjectName(int pIndex, String newName){
    _items[pIndex].name = newName;
    notifyListeners();
    _dbHelper.updateRow(projectsTable, _items[pIndex].id, {
      'userId': 0,
      'name': newName,
    });
  }
  removeProject(int pIndex){
    _items.removeAt(pIndex);
    notifyListeners();
    _dbHelper.deleteRow(projectsTable, _items[pIndex].id);
  }
  editSection(int pIndex, int sIndex, String newName){
    _items[pIndex].sections[sIndex].name = newName;
    notifyListeners();
    _dbHelper.updateRow(sectionsTable, _items[pIndex].sections[sIndex].id, {
      'name': newName,
      'projectId': _items[pIndex].id,
    });
  }
  removeSection(int pIndex, int sIndex){
    _items[pIndex].sections.removeAt(sIndex);
    notifyListeners();
    _dbHelper.deleteRow(sectionsTable, _items[pIndex].sections[sIndex].id);
  }
}