import 'section.dart';

class Project {
  int id;
  int userID;
  String name;
  List<Section> sections = [];

  Project(String name){
     this.name = name;
  }
}