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

  Task() {
    name = '';
    priority = 100;
    DateTime now = DateTime.now();
    id = now.hashCode;
    sectionId = -1;
    projectId = -1;
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
