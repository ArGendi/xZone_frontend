import 'package:flutter/cupertino.dart';

class ZoneTasksProvider extends ChangeNotifier {
  List _items = [];

  List get items {
    return _items;
  }

  addTask(task) {
    _items.add(task);
    notifyListeners();
  }

  addListOfTasks(List tasks){
    _items = tasks;
    notifyListeners();
  }

  clearProviderItems(){
    _items = [];
  }

}