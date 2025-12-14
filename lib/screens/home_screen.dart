import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import '../widgets/task_editor_sheet.dart';
import '../models/task.dart';
import '../utils/priority.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openEditor(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(
        task: task,
        onSave: (updated) {
          final provider = context.read<TaskProvider>();
          if (task == null) {
            provider.create(
              title: updated.title,
              description: updated.description,
              dueDate: updated.dueDate,
              priority: updated.priority,
              tags: updated.tags,
            );
          } else {
            provider.updateTask(updated);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_filters') {
                provider.setFilter(const TaskFilter());
                _searchCtrl.clear();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                  value: 'clear_filters', child: Text('Clear filters')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search tasks, descriptions, tags...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (v) => provider
                        .setFilter(provider.filter.copyWith(searchQuery: v)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<SortBy>(
                    value: provider.sortBy,
                    onChanged: (by) {
                      if (by != null) provider.setSort(by);
                    },
                    items: const [
                      DropdownMenuItem(
                          value: SortBy.createdAt,
                          child: Text('Sort: Created')),
                      DropdownMenuItem(
                          value: SortBy.dueDate, child: Text('Sort: Due')),
                      DropdownMenuItem(
                          value: SortBy.priority,
                          child: Text('Sort: Priority')),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sort by',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: provider.ascending ? 'Ascending' : 'Descending',
                  onPressed: () => provider.setSort(provider.sortBy,
                      ascending: !provider.ascending),
                  icon: Icon(provider.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: provider.filter.completed == null &&
                      !provider.filter.overdueOnly &&
                      provider.filter.priority == null,
                  onSelected: (_) => provider.setFilter(const TaskFilter()),
                ),
                FilterChip(
                  label: const Text('Pending'),
                  selected: provider.filter.completed == false,
                  onSelected: (_) => provider
                      .setFilter(provider.filter.copyWith(completed: false)),
                ),
                FilterChip(
                  label: const Text('Completed'),
                  selected: provider.filter.completed == true,
                  onSelected: (_) => provider
                      .setFilter(provider.filter.copyWith(completed: true)),
                ),
                FilterChip(
                  label: const Text('Overdue'),
                  selected: provider.filter.overdueOnly,
                  onSelected: (_) => provider.setFilter(provider.filter
                      .copyWith(overdueOnly: !provider.filter.overdueOnly)),
                ),
                const SizedBox(width: 8),
                DropdownButton<Priority?>(
                  value: provider.filter.priority,
                  underline: const SizedBox.shrink(),
                  hint: const Text('Priority'),
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('Any priority')),
                    ...Priority.values.map((p) => DropdownMenuItem(
                        value: p, child: Text(priorityLabel(p))))
                  ],
                  onChanged: (p) =>
                      provider.setFilter(provider.filter.copyWith(priority: p)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No tasks yet. Tap + to add one.'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, i) {
                      final t = tasks[i];
                      return TaskItem(
                        task: t,
                        onToggle: (val) =>
                            provider.toggleComplete(t, val ?? false),
                        onEdit: () => _openEditor(context, task: t),
                        onDelete: () => provider.deleteTask(t.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}
