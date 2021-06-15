import 'package:flutter/cupertino.dart';
import 'package:xzone/models/project.dart';

class ProjectsProvider extends ChangeNotifier{
  List<Project> _items = [];

  List get items {
    return _items;
  }

  addProject(Project project){
    _items.add(project);
    notifyListeners();
  }
}