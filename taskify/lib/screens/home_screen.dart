import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/models/priority.dart';
import 'package:taskify/models/category.dart' as task_category;
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/widgets/task_list.dart';
import 'package:taskify/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Taskify',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 110,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                size: 20,
              ),
              onPressed: () {
                themeNotifier.value =
                    Theme.of(context).brightness == Brightness.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                        : [Colors.white, const Color(0xFFF8FAFC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTappableStatColumn(
                          context, 'All', taskProvider.taskCount, () {
                        taskProvider.filterTasks(null);
                      }),
                      Container(
                        height: 40,
                        width: 1,
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                      ),
                      _buildTappableStatColumn(
                          context, 'Completed', taskProvider.completedTaskCount,
                          () {
                        taskProvider.filterTasks(true);
                      }),
                      Container(
                        height: 40,
                        width: 1,
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                      ),
                      _buildTappableStatColumn(
                          context, 'Remaining', taskProvider.remainingTaskCount,
                          () {
                        taskProvider.filterTasks(false);
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sort',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  onSelected: (String value) {
                    final taskProvider =
                        Provider.of<TaskProvider>(context, listen: false);
                    if (value == 'priority') {
                      taskProvider.sortByPriority();
                    } else if (value == 'due_date') {
                      taskProvider.sortByDueDate();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'priority',
                      child: Row(
                        children: [
                          Icon(Icons.priority_high,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text('By Priority'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'due_date',
                      child: Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text('By Due Date'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.primary),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .searchTasks(value);
                },
              ),
            ),
          ),
          const Expanded(
            child: TaskList(),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTaskTitle = '';
    String newTaskDescription = '';
    DateTime? newTaskTime;
    Priority selectedPriority = Priority.medium;
    task_category.Category selectedCategory = task_category.Category.other;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Task',
                  style: Theme.of(context).dialogTheme.titleTextStyle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle:
                            Theme.of(context).inputDecorationTheme.labelStyle),
                    onChanged: (value) {
                      newTaskTitle = value;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle:
                            Theme.of(context).inputDecorationTheme.labelStyle),
                    onChanged: (value) {
                      newTaskDescription = value;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          newTaskTime == null
                              ? 'No time selected'
                              : 'Time: ${TimeOfDay.fromDateTime(newTaskTime!).format(context)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
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
                                newTaskTime = selectedDateTime;
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
                    if (newTaskTitle.isNotEmpty) {
                      Provider.of<TaskProvider>(context, listen: false).addTask(
                          newTaskTitle,
                          newTaskDescription,
                          newTaskTime,
                          selectedPriority,
                          selectedCategory);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTappableStatColumn(
      BuildContext context, String title, int count, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
