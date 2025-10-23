import 'package:flutter/foundation.dart';
import 'package:taskify/models/priority.dart';
import 'package:taskify/models/category.dart' as task_category;
import 'package:taskify/models/task.dart';
import 'package:taskify/services/notification_service.dart';
import 'dart:collection';

class TaskProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = '';

  TaskProvider() {
    _filteredTasks = List.from(_tasks);
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_filteredTasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  int get completedTaskCount {
    return _tasks.where((task) => task.isDone).length;
  }

  int get remainingTaskCount {
    return _tasks.where((task) => !task.isDone).length;
  }

  void addTask(String newTaskTitle, String newDescription, DateTime? newDateTime, Priority priority, task_category.Category category) {
    final task = Task(
      id: DateTime.now().toString(),
      title: newTaskTitle,
      description: newDescription,
      dateTime: newDateTime,
      priority: priority,
      category: category,
    );
    _tasks.add(task);
    _applyFilters();
    notifyListeners();
  }

  void updateTask(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    _applyFilters();
    notifyListeners();
  }

  void editTask(Task task, String newTitle, String newDescription, DateTime? newDateTime, Priority priority, task_category.Category category) {
    task.title = newTitle;
    task.description = newDescription;
    task.dateTime = newDateTime;
    task.priority = priority;
    task.category = category;
    notifyListeners();
  }

  void sortByPriority() {
    _filteredTasks.sort((a, b) {
      final priorityOrder = {
        Priority.high: 0,
        Priority.medium: 1,
        Priority.low: 2,
      };
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });
    notifyListeners();
  }

  void sortByDueDate() {
    _filteredTasks.sort((a, b) {
      if (a.dateTime == null && b.dateTime == null) return 0;
      if (a.dateTime == null) return 1;
      if (b.dateTime == null) return -1;
      return a.dateTime!.compareTo(b.dateTime!);
    });
    notifyListeners();
  }

  void searchTasks(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void filterTasks(bool? isCompleted) {
    if (isCompleted == null) {
      _filteredTasks = List.from(_tasks);
    } else {
      _filteredTasks = _tasks.where((task) => task.isDone == isCompleted).toList();
    }
    _applySearchFilter();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTasks = List.from(_tasks);
    _applySearchFilter();
  }

  void _applySearchFilter() {
    if (_searchQuery.isNotEmpty) {
      _filteredTasks = _filteredTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery) ||
               task.description.toLowerCase().contains(_searchQuery) ||
               (task.category?.displayName.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }
  }
}
