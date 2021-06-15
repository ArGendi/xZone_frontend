import 'package:xzone/models/project.dart';
import 'package:xzone/models/task.dart';

class Section {
  int id;
  String name;
  List<Task> tasks;
  int parentProjectID;
  Project parentProject;
}