import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'auth_provider.dart';

final taskServiceProvider = Provider((ref) {
  return TaskService(ref.watch(apiClientProvider));
});

final tasksProvider = StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>((ref) {
  return TasksNotifier(ref.watch(taskServiceProvider));
});

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskService _taskService;

  TasksNotifier(this._taskService) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks({
    DateTime? startDate,
    DateTime? endDate,
    String? projectId,
    TaskState? state,
  }) async {
    this.state = const AsyncValue.loading();
    try {
      final tasks = await _taskService.getTasks(
        startDate: startDate,
        endDate: endDate,
        projectId: projectId,
        state: state,
      );
      this.state = AsyncValue.data(tasks);
    } catch (e, stack) {
      this.state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createTask({
    required String title,
    String? description,
    required DateTime scheduledDate,
    String? projectId,
    String? assignedTo,
  }) async {
    try {
      await _taskService.createTask(
        title: title,
        description: description,
        scheduledDate: scheduledDate,
        projectId: projectId,
        assignedTo: assignedTo,
      );
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    TaskState? state,
    String? projectId,
    String? assignedTo,
    bool? acknowledged,
  }) async {
    try {
      await _taskService.updateTask(
        id: id,
        title: title,
        description: description,
        scheduledDate: scheduledDate,
        state: state,
        projectId: projectId,
        assignedTo: assignedTo,
        acknowledged: acknowledged,
      );
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rescheduleTask({
    required String id,
    required DateTime newDate,
  }) async {
    try {
      await _taskService.rescheduleTask(id: id, newDate: newDate);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskService.deleteTask(id);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }
}
