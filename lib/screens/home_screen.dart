import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../view_models/task_view_model.dart';


class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends ConsumerState<HomepageScreen> {
  bool _showAllTasks = true;

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskViewModelProvider);
    final taskViewModel = ref.read(taskViewModelProvider.notifier);

    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM. yyyy').format(now);
    final greeting = _getGreeting(now);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
               Color(0xFFE6E6FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(greeting, formattedDate),
              _buildSummaryCards(taskState),
              _buildTodayTasks(taskState, taskViewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String greeting, String formattedDate) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(TaskState taskState) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Assigned tasks',
                  taskState.assignedTasksCount,
                  const Color(0xFFE8D7F5),
                  const Color(0xFF7B2CBF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Completed tasks',
                  taskState.completedTasksCount,
                  const Color(0xFFD1F5E8),
                  const Color(0xFF06D6A0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasks(TaskState taskState, TaskViewModel taskViewModel) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all( 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),


                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                  ),
                  padding: const EdgeInsets.all(3), // Add some padding inside the container
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAllTasks = true;
                            });
                          },
                          child: _buildFilterChip('All tasks', _showAllTasks),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAllTasks = false;
                            });
                          },
                          child: _buildFilterChip('Completed', !_showAllTasks),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final displayTasks = _showAllTasks
                    ? taskState.todayTasks
                    : taskState.todayTasks.where((task) => task.isCompleted).toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: displayTasks.length,
                  itemBuilder: (context, index) {
                    final task = displayTasks[index];
                    return _buildTaskItem(task, taskViewModel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF7B2CBF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey[300]!,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task, TaskViewModel taskViewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            task.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(task.endDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  taskViewModel.toggleTaskCompletion(task);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? const Color(0xFFD1F5E8)
                        : const Color(0xFFE8D7F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.isCompleted ? 'Complete' : 'Todo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted
                          ? const Color(0xFF06D6A0)
                          : const Color(0xFF7B2CBF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'Good morning Sir !';
    if (hour < 17) return 'Good afternoon Sir !';
    return 'Good evening Sir !';
  }
}