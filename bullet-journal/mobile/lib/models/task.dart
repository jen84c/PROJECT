import 'package:equatable/equatable.dart';

enum TaskState {
  notDone('not_done'),
  done('done'),
  blocked('blocked'),
  rescheduled('rescheduled');

  final String value;
  const TaskState(this.value);

  static TaskState fromString(String value) {
    return TaskState.values.firstWhere((e) => e.value == value);
  }
}

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduledDate;
  final TaskState state;
  final String createdBy;
  final String? assignedTo;
  final bool acknowledged;
  final String? projectId;
  final int migrationCount;
  final String? rescheduledFrom;
  final String? rescheduledTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  final String? creatorName;
  final String? assigneeName;
  final String? projectName;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledDate,
    required this.state,
    required this.createdBy,
    this.assignedTo,
    this.acknowledged = false,
    this.projectId,
    this.migrationCount = 0,
    this.rescheduledFrom,
    this.rescheduledTo,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.creatorName,
    this.assigneeName,
    this.projectName,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      state: TaskState.fromString(json['state']),
      createdBy: json['created_by'],
      assignedTo: json['assigned_to'],
      acknowledged: json['acknowledged'] ?? false,
      projectId: json['project_id'],
      migrationCount: json['migration_count'] ?? 0,
      rescheduledFrom: json['rescheduled_from'],
      rescheduledTo: json['rescheduled_to'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      creatorName: json['creator_name'],
      assigneeName: json['assignee_name'],
      projectName: json['project_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
      'state': state.value,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'acknowledged': acknowledged,
      'project_id': projectId,
      'migration_count': migrationCount,
      'rescheduled_from': rescheduledFrom,
      'rescheduled_to': rescheduledTo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    TaskState? state,
    String? createdBy,
    String? assignedTo,
    bool? acknowledged,
    String? projectId,
    int? migrationCount,
    String? rescheduledFrom,
    String? rescheduledTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      state: state ?? this.state,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      acknowledged: acknowledged ?? this.acknowledged,
      projectId: projectId ?? this.projectId,
      migrationCount: migrationCount ?? this.migrationCount,
      rescheduledFrom: rescheduledFrom ?? this.rescheduledFrom,
      rescheduledTo: rescheduledTo ?? this.rescheduledTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  String get signifier {
    switch (state) {
      case TaskState.done:
        return 'X';
      case TaskState.rescheduled:
        return '>';
      case TaskState.blocked:
        return '⊗';
      case TaskState.notDone:
      default:
        return '•';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        scheduledDate,
        state,
        createdBy,
        assignedTo,
        acknowledged,
        projectId,
        migrationCount,
        rescheduledFrom,
        rescheduledTo,
        createdAt,
        updatedAt,
        completedAt,
      ];
}
