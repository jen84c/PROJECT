import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.signifier,
                    style: TextStyle(
                      fontSize: 18,
                      color: _getSignifierColor(task.state),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            decoration: task.state == TaskState.done
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.state == TaskState.done
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        if (task.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (task.projectName != null ||
                  task.assigneeName != null ||
                  task.migrationCount > 0) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (task.projectName != null)
                      Chip(
                        label: Text(task.projectName!),
                        visualDensity: VisualDensity.compact,
                      ),
                    if (task.assigneeName != null)
                      Chip(
                        label: Text('👤 ${task.assigneeName!}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    if (task.migrationCount > 0)
                      Chip(
                        label: Text('⚠️ Migrated ${task.migrationCount}x'),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: task.migrationCount >= 2
                            ? Colors.orange.shade100
                            : null,
                      ),
                  ],
                ),
              ],
              if (task.state == TaskState.rescheduled &&
                  task.rescheduledTo != null) ...[
                const SizedBox(height: 8),
                Text(
                  '→ Rescheduled',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getSignifierColor(TaskState state) {
    switch (state) {
      case TaskState.done:
        return Colors.green;
      case TaskState.blocked:
        return Colors.red;
      case TaskState.rescheduled:
        return Colors.blue;
      case TaskState.notDone:
      default:
        return Colors.black;
    }
  }
}
