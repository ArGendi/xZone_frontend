class Task {
  int id;
  int userId;
  int parentId;
  String name;
  DateTime dueDate;
  DateTime remainder;
  DateTime completeDate;
  int priority;
  int sectionId;
  int projectId;
  bool remainderOn;

  Task() {
    name = '';
    priority = 100;
    DateTime now = DateTime.now();
    id = now.hashCode;
    sectionId = 0;
    projectId = 0;
    remainderOn = false;
  }
  TaskMapping() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['userid'] = userId;
    mapping['parentid'] = parentId;
    mapping['dueDate'] = dueDate.toString();
    mapping['completeDate'] = completeDate.toString();
    mapping['remainder'] = remainder.toString();
    mapping['priority'] = priority;
    return mapping;
  }
}
