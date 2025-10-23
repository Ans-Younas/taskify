import 'package:flutter/material.dart';
import 'package:taskify/models/priority.dart';
import 'package:taskify/models/category.dart' as task_category;
import 'package:taskify/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;
  final Function(String, String, DateTime?, Priority, task_category.Category)
      onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(task.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onChanged(!task.isDone);
          } else {
            onDelete();
          }
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () =>
                onChanged(!task.isDone), // Subtle visual feedback for taps
            borderRadius: BorderRadius.circular(15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: task.isDone
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : task.isOverdue
                        ? Colors.red.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: task.isOverdue && !task.isDone
                    ? Border.all(color: Colors.red.withOpacity(0.3), width: 1)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0), // Increased horizontal padding
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: task.isDone,
                        onChanged: onChanged,
                        activeColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (task.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                task.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.7),
                                    ),
                              ),
                            ),
                          if (task.dateTime != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDateTime(task.dateTime!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                _buildPriorityIndicator(task.priority),
                                const SizedBox(width: 8),
                                _buildCategoryChip(task.category ?? task_category.Category.other),
                                if (task.isOverdue && !task.isDone) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'OVERDUE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditDialog(context),
                          tooltip: 'Edit Task',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: onDelete,
                          tooltip: 'Delete Task',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showEditDialog(BuildContext context) {
    String updatedTaskTitle = task.title;
    String updatedTaskDescription = task.description;
    DateTime? updatedTaskTime = task.dateTime;
    Priority selectedPriority = task.priority;
    task_category.Category selectedCategory = task.category ?? task_category.Category.other;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Task',
                  style: Theme.of(context).dialogTheme.titleTextStyle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    controller: TextEditingController(text: updatedTaskTitle),
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle:
                            Theme.of(context).inputDecorationTheme.labelStyle),
                    onChanged: (value) {
                      updatedTaskTitle = value;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller:
                        TextEditingController(text: updatedTaskDescription),
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle:
                            Theme.of(context).inputDecorationTheme.labelStyle),
                    onChanged: (value) {
                      updatedTaskDescription = value;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          updatedTaskTime == null
                              ? 'No time selected'
                              : 'Time: ${TimeOfDay.fromDateTime(updatedTaskTime!).format(context)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final currentTime = TimeOfDay.now();
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: updatedTaskTime != null
                                ? TimeOfDay.fromDateTime(updatedTaskTime!)
                                : currentTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme:
                                      Theme.of(context).colorScheme.copyWith(
                                            primary: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onSurface: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (selectedTime != null) {
                            final selectedDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            if (selectedDateTime.isAfter(now)) {
                              setState(() {
                                updatedTaskTime = selectedDateTime;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a future time'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Select Time'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Priority>(
                          value: selectedPriority,
                          dropdownColor: Theme.of(context).cardColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (Priority? newValue) {
                            setState(() {
                              selectedPriority = newValue!;
                            });
                          },
                          items: Priority.values
                              .map<DropdownMenuItem<Priority>>(
                                  (Priority value) {
                            return DropdownMenuItem<Priority>(
                              value: value,
                              child: Text(value.toString().split('.').last),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<task_category.Category>(
                          value: selectedCategory,
                          dropdownColor: Theme.of(context).cardColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (task_category.Category? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          items: task_category.Category.values
                              .map<DropdownMenuItem<task_category.Category>>(
                                  (task_category.Category value) {
                            return DropdownMenuItem<task_category.Category>(
                              value: value,
                              child: Text(value.displayName),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (updatedTaskTitle.isNotEmpty) {
                      onEdit(updatedTaskTitle, updatedTaskDescription,
                          updatedTaskTime, selectedPriority, selectedCategory);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityIndicator(Priority priority) {
    Color color;
    String text;

    switch (priority) {
      case Priority.high:
        color = Colors.red;
        text = 'High';
        break;
      case Priority.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case Priority.low:
        color = Colors.green;
        text = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1), // Thin color strip
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (taskDate == today) {
      dateStr = 'Today';
    } else if (taskDate == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      dateStr = '${months[dateTime.month - 1]} ${dateTime.day}';
    }

    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';

    return '$dateStr • $timeStr';
  }

  Widget _buildCategoryChip(task_category.Category category) {
    final colors = {
      task_category.Category.work: Colors.blue,
      task_category.Category.personal: Colors.purple,
      task_category.Category.shopping: Colors.orange,
      task_category.Category.health: Colors.green,
      task_category.Category.education: Colors.indigo,
      task_category.Category.other: Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[category]!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors[category]!, width: 1),
      ),
      child: Text(
        category.displayName,
        style: TextStyle(
          color: colors[category],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
