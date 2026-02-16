import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String color;
  final String? icon;
  final String createdBy;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? creatorName;
  final int? activeTaskCount;

  const Project({
    required this.id,
    required this.name,
    this.description,
    this.color = '#6B7280',
    this.icon,
    required this.createdBy,
    this.archived = false,
    required this.createdAt,
    required this.updatedAt,
    this.creatorName,
    this.activeTaskCount,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'] ?? '#6B7280',
      icon: json['icon'],
      createdBy: json['created_by'],
      archived: json['archived'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      creatorName: json['creator_name'],
      activeTaskCount: json['active_task_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
      'created_by': createdBy,
      'archived': archived,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        icon,
        createdBy,
        archived,
        createdAt,
        updatedAt,
      ];
}
