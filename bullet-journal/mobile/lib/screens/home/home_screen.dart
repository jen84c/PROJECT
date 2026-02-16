import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_tile.dart';
import '../tasks/create_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    ref.read(tasksProvider.notifier).loadTasks(
          startDate: startOfDay,
          endDate: endOfDay,
        );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Log'),
            Text(
              DateFormat('EEEE, MMM d').format(_selectedDate),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
                _loadTasks();
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authStateProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadTasks(),
        child: tasksAsync.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks for today',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to create your first task',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              );
            }

            final notDoneTasks = tasks.where((t) => t.state != TaskState.done).toList();
            final doneTasks = tasks.where((t) => t.state == TaskState.done).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (authState.user != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Welcome, ${authState.user!.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                if (notDoneTasks.isNotEmpty) ...[
                  ...notDoneTasks.map((task) => TaskTile(
                        task: task,
                        onTap: () => _showTaskActions(context, task),
                      )),
                ],
                if (doneTasks.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...doneTasks.map((task) => TaskTile(
                        task: task,
                        onTap: () => _showTaskActions(context, task),
                      )),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loadTasks,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(date: _selectedDate),
            ),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTaskActions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  task.state == TaskState.done
                      ? Icons.radio_button_unchecked
                      : Icons.check_circle,
                ),
                title: Text(
                  task.state == TaskState.done ? 'Mark as Not Done' : 'Mark as Done',
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(tasksProvider.notifier).updateTask(
                        id: task.id,
                        state: task.state == TaskState.done
                            ? TaskState.notDone
                            : TaskState.done,
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Reschedule'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: task.scheduledDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null && context.mounted) {
                    try {
                      await ref.read(tasksProvider.notifier).rescheduleTask(
                            id: task.id,
                            newDate: picked,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task rescheduled')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Mark as Blocked'),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(tasksProvider.notifier).updateTask(
                        id: task.id,
                        state: TaskState.blocked,
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(tasksProvider.notifier).deleteTask(task.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
