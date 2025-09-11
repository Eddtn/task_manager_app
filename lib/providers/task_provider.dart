import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/task_store.dart';
import '../utils/priority.dart';

class TaskFilter {
  final bool? completed; // null=all, true=completed, false=pending
  final Priority? priority;
  final String searchQuery;
  final bool overdueOnly;

  const TaskFilter({
    this.completed,
    this.priority,
    this.searchQuery = '',
    this.overdueOnly = false,
  });

  TaskFilter copyWith({
    bool? completed,
    Priority? priority,
    String? searchQuery,
    bool? overdueOnly,
  }) {
    return TaskFilter(
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      searchQuery: searchQuery ?? this.searchQuery,
      overdueOnly: overdueOnly ?? this.overdueOnly,
    );
  }
}

enum SortBy { createdAt, dueDate, priority }

class TaskProvider extends ChangeNotifier {
  final TaskStore store;
  final _uuid = const Uuid();

  TaskProvider(this.store);

  List<Task> _tasks = [];
  TaskFilter _filter = const TaskFilter();
  SortBy _sortBy = SortBy.createdAt;
  bool _ascending = false;

  List<Task> get tasks {
    var list = List<Task>.from(_tasks);
    // filter
    if (_filter.completed != null) {
      list = list.where((t) => t.isCompleted == _filter.completed).toList();
    }
    if (_filter.priority != null) {
      list = list.where((t) => t.priority == _filter.priority).toList();
    }
    if (_filter.overdueOnly) {
      final now = DateTime.now();
      list = list.where((t) => (t.dueDate != null && t.dueDate!.isBefore(now) && !t.isCompleted)).toList();
    }
    if (_filter.searchQuery.trim().isNotEmpty) {
      final q = _filter.searchQuery.toLowerCase();
      list = list.where((t) =>
        t.title.toLowerCase().contains(q) ||
        (t.description ?? '').toLowerCase().contains(q) ||
        t.tags.any((tag) => tag.toLowerCase().contains(q))
      ).toList();
    }
    // sort
    list.sort((a, b) {
      int cmp;
      switch (_sortBy) {
        case SortBy.createdAt:
          cmp = a.createdAt.compareTo(b.createdAt);
          break;
        case SortBy.dueDate:
          cmp = (a.dueDate ?? DateTime(9999)).compareTo(b.dueDate ?? DateTime(9999));
          break;
        case SortBy.priority:
          cmp = priorityRank(a.priority).compareTo(priorityRank(b.priority));
          break;
      }
      return _ascending ? cmp : -cmp;
    });
    return list;
  }

  TaskFilter get filter => _filter;
  SortBy get sortBy => _sortBy;
  bool get ascending => _ascending;

  Future<void> load() async {
    _tasks = store.getAll();
    notifyListeners();
  }

  Future<void> create({
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    List<String>? tags,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      isCompleted: false,
      tags: tags ?? [],
    );
    await store.add(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> toggleComplete(Task task, bool value) async {
    final updated = task.copyWith(isCompleted: value);
    await store.update(updated);
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    _tasks[idx] = updated;
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await store.update(task);
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    _tasks[idx] = task;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await store.delete(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setFilter(TaskFilter f) {
    _filter = f;
    notifyListeners();
  }

  void setSort(SortBy by, {bool? ascending}) {
    _sortBy = by;
    if (ascending != null) _ascending = ascending;
    notifyListeners();
  }
}
