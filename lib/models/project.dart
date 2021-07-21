import 'section.dart';

class Project {
  int id;
  int userID;
  String name;
  String description;
  List<Section> sections = [];

  Project(String name){
     this.name = name;
     DateTime now = DateTime.now();
     id = now.hashCode;
     description = '';
  }
}