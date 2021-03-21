class Task{
  int id;
  int userId;
  int parentId;
  String name;
  DateTime date;
  DateTime remainder;
  DateTime completeDate;
  int priority;

  Task(){
    name = '';
    priority = 100;
    date = DateTime.now();
  }
}