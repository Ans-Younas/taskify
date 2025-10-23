import 'package:taskify/models/priority.dart';
import 'package:taskify/models/category.dart' as task_category;

class Task {
  final String id;
  String title;
  String description;
  DateTime? dateTime;
  Priority priority;
  task_category.Category? category;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dateTime,
    this.priority = Priority.medium,
    this.category,
    this.isDone = false,
  });

  bool get isOverdue {
    if (dateTime == null || isDone) return false;
    return dateTime!.isBefore(DateTime.now());
  }
}
