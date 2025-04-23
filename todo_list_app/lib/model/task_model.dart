// lib/task_model.dart
class Task {
  String title;
  DateTime? dueDate;
  bool isDone;

  Task({required this.title, this.dueDate, this.isDone = false});
}
