import 'package:flutter/cupertino.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/section.dart';
import 'package:xzone/models/task.dart';

class ProjectsProvider extends ChangeNotifier{
  List<Project> _items = [];

  List get items {
    return _items;
  }

  addProject(Project project){
    _items.add(project);
    notifyListeners();
  }
  addTaskToSection(int pIndex, int sIndex, Task task){
    _items[pIndex].sections[sIndex].tasks.add(task);
    notifyListeners();
  }
  addSection(int pIndex, Section section){
    _items[pIndex].sections.add(section);
    notifyListeners();
  }
  editProjectName(int pIndex, String newName){
    _items[pIndex].name = newName;
    notifyListeners();
  }
  removeProject(int pIndex){
    _items.removeAt(pIndex);
    notifyListeners();
  }
  editSection(int pIndex, int sIndex, String newName){
    _items[pIndex].sections[sIndex].name = newName;
    notifyListeners();
  }
  removeSection(int pIndex, int sIndex){
    _items[pIndex].sections.removeAt(sIndex);
    notifyListeners();
  }
}