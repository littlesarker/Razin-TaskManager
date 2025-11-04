import 'package:riverpod/legacy.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

final taskViewModelProvider = StateNotifierProvider<TaskViewModel, TaskState>(
      (ref) => TaskViewModel(),
);

class TaskState {
  final List<Task> tasks;
  final List<Task> todayTasks;
  final List<Task> completedTasks;
  final int assignedTasksCount;
  final int completedTasksCount;
  final bool isLoading;

  TaskState({
    this.tasks = const [],
    this.todayTasks = const [],
    this.completedTasks = const [],
    this.assignedTasksCount = 0,
    this.completedTasksCount = 0,
    this.isLoading = false,
  });

  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? todayTasks,
    List<Task>? completedTasks,
    int? assignedTasksCount,
    int? completedTasksCount,
    bool? isLoading,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      todayTasks: todayTasks ?? this.todayTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      assignedTasksCount: assignedTasksCount ?? this.assignedTasksCount,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TaskViewModel extends StateNotifier<TaskState> {
  final DatabaseService _databaseService = DatabaseService();

  TaskViewModel() : super(TaskState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);

    final tasks = await _databaseService.getTasks();
    final todayTasks = await _databaseService.getTodayTasks();
    final completedTasks = await _databaseService.getCompletedTasks();
    final assignedCount = await _databaseService.getAssignedTasksCount();
    final completedCount = await _databaseService.getCompletedTasksCount();

    state = state.copyWith(
      tasks: tasks,
      todayTasks: todayTasks,
      completedTasks: completedTasks,
      assignedTasksCount: assignedCount,
      completedTasksCount: completedCount,
      isLoading: false,
    );
  }

  Future<void> addTask(Task task) async {
    await _databaseService.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _databaseService.updateTask(updatedTask);
    await loadTasks();
  }
}