

import 'package:flutter/material.dart';
import 'package:lista/app/model/Repository/TaskRepository.dart';
import 'package:lista/app/model/task.dart';

class  TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];

  final TaskRepository _taskRepository = TaskRepository();

  Future<void> fetchTasks () async {
    _taskList = await _taskRepository.getTasks();
    notifyListeners();
  }

  List<Task> get taskList => _taskList;

  void onTaskDoneChange (Task task) {
    task.done = !task.done;
    _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  void addNewTask(Task task) {
    _taskList.add(task);
    _taskRepository.addTask(task);
    notifyListeners();
  }
  void removeCompletedTasks() {
    _taskList.removeWhere((task) => task.done);
    _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }
}

