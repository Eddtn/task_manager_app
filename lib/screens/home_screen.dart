import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_flutter/models/task_filter.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import '../widgets/task_editor_sheet.dart';
import '../models/task.dart';
import '../utils/priority.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      context.read<TaskProvider>().setFilter(
            context
                .read<TaskProvider>()
                .filter
                .copyWith(searchQuery: query.trim()),
          );
    });
  }

  Future<void> _onRefresh() async {
    // If you add sync/persistence later (e.g., Hive, Firebase), refresh here
    await Future.delayed(const Duration(seconds: 1)); // placeholder
  }

  void _openEditor(BuildContext context, {Task? task}) {
    final isNew = task == null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent, // Allows custom shape + shadow
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Or Theme.of(context).colorScheme.surface
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Elegant drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Row(
                children: [
                  Text(
                    isNew ? 'New Task' : 'Edit Task',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: TaskEditorSheet(
                task: task,
                onSave: (updated) {
                  final provider = context.read<TaskProvider>();
                  if (isNew) {
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
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              title: const Text('Task Manager'),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear_filters') {
                      context.read<TaskProvider>().setFilter(TaskFilter());
                      _searchController.clear();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'clear_filters', child: Text('Clear filters')),
                  ],
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: _SearchAndSortBar(
                  controller: _searchController,
                  onSearchChanged: _onSearchChanged,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _FilterChipsRow(),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 12)),
            Consumer<TaskProvider>(
              builder: (context, provider, _) {
                final tasks = provider.tasks;

                if (tasks.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined,
                              size: 80, color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks yet',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to create one',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskItem(
                      key: ValueKey(
                          task.id), // Important for animations/reordering later
                      task: task,
                      onToggle: (val) =>
                          provider.toggleComplete(task, val ?? false),
                      onEdit: () => _openEditor(context),

                      // _openEditor(task: task),
                      onDelete: () => provider.deleteTask(task.id),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        tooltip: 'New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Extracted widgets for clarity and performance

class _SearchAndSortBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;

  const _SearchAndSortBar({
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search tasks, descriptions, tags...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
            ),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: DropdownButtonFormField<SortBy>(
            value: provider.sortBy,
            decoration: const InputDecoration(
              labelText: 'Sort by',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                  value: SortBy.createdAt, child: Text('Sort: Created')),
              DropdownMenuItem(value: SortBy.dueDate, child: Text('Sort: Due')),
              DropdownMenuItem(
                  value: SortBy.priority, child: Text('Sort: Priority')),
            ],
            onChanged: (value) =>
                value != null ? provider.setSort(value) : null,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: provider.ascending ? 'Ascending' : 'Descending',
          onPressed: () =>
              provider.setSort(provider.sortBy, ascending: !provider.ascending),
          icon: Icon(
              provider.ascending ? Icons.arrow_upward : Icons.arrow_downward),
        ),
      ],
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: const Text('All'),
          selected: provider.filter.isDefault,
          onSelected: (_) => provider.setFilter(const TaskFilter()),
        ),
        FilterChip(
          label: const Text('Pending'),
          selected: provider.filter.completed == false,
          onSelected: (_) =>
              provider.setFilter(provider.filter.copyWith(completed: false)),
        ),
        FilterChip(
          label: const Text('Completed'),
          selected: provider.filter.completed == true,
          onSelected: (_) =>
              provider.setFilter(provider.filter.copyWith(completed: true)),
        ),
        FilterChip(
          label: const Text('Overdue'),
          selected: provider.filter.overdueOnly,
          onSelected: (_) => provider.setFilter(provider.filter.copyWith(
            overdueOnly: !provider.filter.overdueOnly,
            completed: null, // optional: reset completed when toggling overdue
          )),
        ),
        DropdownButton<Priority?>(
          value: provider.filter.priority,
          hint: const Text('Priority'),
          underline: const SizedBox(),
          items: [
            const DropdownMenuItem(value: null, child: Text('Any priority')),
            ...Priority.values.map((p) =>
                DropdownMenuItem(value: p, child: Text(priorityLabel(p)))),
          ],
          onChanged: (p) =>
              provider.setFilter(provider.filter.copyWith(priority: p)),
        ),
      ],
    );
  }
}
