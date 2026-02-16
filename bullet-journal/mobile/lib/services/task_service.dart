import '../models/task.dart';
import 'api_client.dart';

class TaskService {
  final ApiClient _apiClient;

  TaskService(this._apiClient);

  Future<List<Task>> getTasks({
    DateTime? startDate,
    DateTime? endDate,
    String? projectId,
    TaskState? state,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
    }
    if (projectId != null) {
      queryParams['projectId'] = projectId;
    }
    if (state != null) {
      queryParams['state'] = state.value;
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _apiClient.get(
      '/tasks${queryString.isNotEmpty ? '?$queryString' : ''}',
    );

    return (response['tasks'] as List)
        .map((json) => Task.fromJson(json))
        .toList();
  }

  Future<Task> createTask({
    required String title,
    String? description,
    required DateTime scheduledDate,
    String? projectId,
    String? assignedTo,
  }) async {
    final response = await _apiClient.post('/tasks', {
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String().split('T')[0],
      'projectId': projectId,
      'assignedTo': assignedTo,
    });

    return Task.fromJson(response['task']);
  }

  Future<Task> updateTask({
    required String id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    TaskState? state,
    String? projectId,
    String? assignedTo,
    bool? acknowledged,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (scheduledDate != null) {
      data['scheduledDate'] = scheduledDate.toIso8601String().split('T')[0];
    }
    if (state != null) data['state'] = state.value;
    if (projectId != null) data['projectId'] = projectId;
    if (assignedTo != null) data['assignedTo'] = assignedTo;
    if (acknowledged != null) data['acknowledged'] = acknowledged;

    final response = await _apiClient.patch('/tasks/$id', data);
    return Task.fromJson(response['task']);
  }

  Future<RescheduleResult> rescheduleTask({
    required String id,
    required DateTime newDate,
  }) async {
    try {
      final response = await _apiClient.post(
        '/tasks/$id/reschedule',
        {'newDate': newDate.toIso8601String().split('T')[0]},
      );

      return RescheduleResult(
        originalTask: Task.fromJson(response['originalTask']),
        newTask: Task.fromJson(response['newTask']),
        migrationCount: response['migrationCount'],
      );
    } on ApiException catch (e) {
      if (e.statusCode == 400 && e.message.contains('Migration limit')) {
        throw MigrationLimitException(
          message: e.message,
          migrationCount: 3,
        );
      }
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    await _apiClient.delete('/tasks/$id');
  }
}

class RescheduleResult {
  final Task originalTask;
  final Task newTask;
  final int migrationCount;

  RescheduleResult({
    required this.originalTask,
    required this.newTask,
    required this.migrationCount,
  });
}

class MigrationLimitException implements Exception {
  final String message;
  final int migrationCount;

  MigrationLimitException({
    required this.message,
    required this.migrationCount,
  });

  @override
  String toString() => message;
}
