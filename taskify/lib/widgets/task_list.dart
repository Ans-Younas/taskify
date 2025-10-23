import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return ListView.builder(
          itemCount: taskProvider.tasks.length, // Use filtered tasks length
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];
            return TaskTile(
              task: task,
              onChanged: (value) {
                taskProvider.updateTask(task);
              },
              onDelete: () {
                taskProvider.deleteTask(task);
              },
              onEdit: (newTitle, newDescription, newDateTime, priority, category) {
                taskProvider.editTask(
                    task, newTitle, newDescription, newDateTime, priority, category);
              },
            );
          },
        );
      },
    );
  }
}
