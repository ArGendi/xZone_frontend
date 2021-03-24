class Task{
  int id;
  int userId;
  int parentId;
  String name;
  DateTime dueDate;
  DateTime remainder;
  DateTime completeDate;
  int priority;

  Task(){
    name = '';
    priority = 100;
    dueDate = DateTime.now();
    remainder = DateTime.now();
  }
}