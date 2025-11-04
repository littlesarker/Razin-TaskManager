import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:taskmanagement/screens/view_task_screen.dart';
import '../models/task_model.dart';
import '../view_models/task_view_model.dart';


final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskViewModelProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    // Get current date
    final now = DateTime.now();

    // Generate dates for the week view
    final weekDates = List.generate(7, (index) {
      return now.subtract(Duration(days: 3 - index));
    });

    // Filter tasks based on selected date
    final filteredTasks = taskState.tasks.where((task) {
      return task.startDate.year == selectedDate.year &&
          task.startDate.month == selectedDate.month &&
          task.startDate.day == selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFDEDEF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'All Task',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                // Navigate to create task screen
              },
              child: const Text(
                'Create New',
                style: TextStyle(
                  color: Color(0xFF7C5CFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: weekDates.length,
                itemBuilder: (context, index) {
                  final date = weekDates[index];
                  final isSelected = date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedDateProvider.notifier).state = date;
                    },
                    child: Container(
                      width: 55,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7C5CFF)
                            : Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Tasks list
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks for this date',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to ViewTaskScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewTaskScreen(task: task),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.isCompleted ? 'Complete' : 'Todo',
                                style: TextStyle(
                                  color: task.isCompleted
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFFF9800),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMMM dd, yyyy')
                                  .format(task.startDate),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
