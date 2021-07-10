import 'package:xzone/models/task.dart';
import 'package:xzone/repositories/repository.dart';

class Taskservice {
  Repositery _repositery;
  Taskservice() {
    _repositery = Repositery();
  }

  savetask(Task task) async {
    return await _repositery.insertData('Tasks', task.TaskMapping());
  }

  readtasks() async {
    return await _repositery.readData('Tasks');
  }
}
