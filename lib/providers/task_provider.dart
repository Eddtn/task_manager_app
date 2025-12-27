// import 'package:flutter/foundation.dart';
// import 'package:uuid/uuid.dart';
// import '../models/task.dart';
// import '../services/task_store.dart';
// import '../utils/priority.dart';

// class TaskFilter {
//   final bool? completed;
//   final Priority? priority;
//   final String searchQuery;
//   final bool overdueOnly;

//   const TaskFilter({
//     this.completed,
//     this.priority,
//     this.searchQuery = '',
//     this.overdueOnly = false,
//   });

//   TaskFilter copyWith({
//     bool? completed,
//     Priority? priority,
//     String? searchQuery,
//     bool? overdueOnly,
//   }) {
//     return TaskFilter(
//       completed: completed ?? this.completed,
//       priority: priority ?? this.priority,
//       searchQuery: searchQuery ?? this.searchQuery,
//       overdueOnly: overdueOnly ?? this.overdueOnly,
//     );
//   }

//   /// Useful for UI: "All" chip selection
//   bool get isDefault =>
//       completed == null &&
//       priority == null &&
//       searchQuery.trim().isEmpty &&
//       !overdueOnly;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TaskFilter &&
//           runtimeType == other.runtimeType &&
//           completed == other.completed &&
//           priority == other.priority &&
//           searchQuery == other.searchQuery &&
//           overdueOnly == other.overdueOnly;

//   @override
//   int get hashCode =>
//       completed.hashCode ^
//       priority.hashCode ^
//       searchQuery.hashCode ^
//       overdueOnly.hashCode;
// }

// enum SortBy { createdAt, dueDate, priority }

// class TaskProvider extends ChangeNotifier {
//   final TaskStore store;
//   final _uuid = Uuid();

//   // Private immutable state
//   List<Task> _tasks = [];
//   TaskFilter _filter = const TaskFilter();
//   SortBy _sortBy = SortBy.createdAt;
//   bool _ascending = false;

//   // Cached filtered/sorted list – recomputed only when needed
//   List<Task>? _cachedTasks;

//   TaskProvider(this.store);

//   List<Task> get tasks {
//     // Invalidate cache if filter/sort changed or tasks mutated
//     final shouldRecompute = _cachedTasks == null;
//     if (shouldRecompute) {
//       _cachedTasks = _computeFilteredAndSortedTasks();
//     }
//     return _cachedTasks!;
//   }

//   List<Task> _computeFilteredAndSortedTasks() {
//     List<Task> list = List.unmodifiable(_tasks); // Prevent external mutation

//     // === Filtering ===
//     final query = _filter.searchQuery.trim().toLowerCase();
//     final hasSearch = query.isNotEmpty;
//     final now = DateTime.now();

//     list = list.where((task) {
//       // Completed filter
//       if (_filter.completed != null && task.isCompleted != _filter.completed) {
//         return false;
//       }

//       // Priority filter
//       if (_filter.priority != null && task.priority != _filter.priority) {
//         return false;
//       }

//       // Overdue only
//       if (_filter.overdueOnly) {
//         final hasDueDate = task.dueDate != null;
//         final isOverdue = hasDueDate && task.dueDate!.isBefore(now);
//         if (!isOverdue || task.isCompleted) return false;
//       }

//       // Search query
//       if (hasSearch) {
//         final titleMatch = task.title.toLowerCase().contains(query);
//         final descMatch =
//             (task.description ?? '').toLowerCase().contains(query);
//         final tagMatch =
//             task.tags.any((tag) => tag.toLowerCase().contains(query));
//         if (!(titleMatch || descMatch || tagMatch)) return false;
//       }

//       return true;
//     }).toList();

//     // === Sorting ===
//     list.sort((a, b) {
//       int cmp = 0;
//       switch (_sortBy) {
//         case SortBy.createdAt:
//           cmp = a.createdAt.compareTo(b.createdAt);
//           break;
//         case SortBy.dueDate:
//           final aDate =
//               a.dueDate ?? DateTime(9999, 12, 31); // Far future for nulls
//           final bDate = b.dueDate ?? DateTime(9999, 12, 31);
//           cmp = aDate.compareTo(bDate);
//           break;
//         case SortBy.priority:
//           cmp = priorityRank(a.priority).compareTo(priorityRank(b.priority));
//           break;
//       }
//       return _ascending ? cmp : -cmp;
//     });

//     return List.unmodifiable(list);
//   }

//   TaskFilter get filter => _filter;
//   SortBy get sortBy => _sortBy;
//   bool get ascending => _ascending;

//   // === State Mutations ===

//   Future<void> load() async {
//     try {
//       _tasks = await store.getAll();
//       _invalidateCache();
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error loading tasks: $e');
//       // Optionally expose error via another stream/state
//     }
//   }

//   Future<void> create({
//     required String title,
//     String? description,
//     DateTime? dueDate,
//     Priority priority = Priority.medium,
//     List<String> tags = const [],
//   }) async {
//     final task = Task(
//       id: _uuid.v4(),
//       title: title.trim(),
//       description: description?.trim(),
//       dueDate: dueDate,
//       priority: priority,
//       isCompleted: false,
//       createdAt: DateTime.now(),
//       tags: tags,
//     );

//     await store.add(task);
//     _tasks = List.from(_tasks)..add(task);
//     _invalidateCache();
//     notifyListeners();
//   }

//   Future<void> toggleComplete(Task task, bool value) async {
//     final updated = task.copyWith(isCompleted: value);
//     await store.update(updated);

//     _tasks = _tasks.map((t) => t.id == task.id ? updated : t).toList();
//     _invalidateCache();
//     notifyListeners();
//   }

//   Future<void> updateTask(Task updatedTask) async {
//     await store.update(updatedTask);

//     _tasks =
//         _tasks.map((t) => t.id == updatedTask.id ? updatedTask : t).toList();
//     _invalidateCache();
//     notifyListeners();
//   }

//   Future<void> deleteTask(String id) async {
//     await store.delete(id);

//     _tasks = _tasks.where((t) => t.id != id).toList();
//     _invalidateCache();
//     notifyListeners();
//   }

//   // === Filter & Sort Controls ===

//   void setFilter(TaskFilter newFilter) {
//     if (_filter == newFilter) return;
//     _filter = newFilter;
//     _invalidateCache();
//     notifyListeners();
//   }

//   void setSort(SortBy by, {bool? ascending}) {
//     bool changed = false;
//     if (_sortBy != by) {
//       _sortBy = by;
//       changed = true;
//     }
//     if (ascending != null && _ascending != ascending) {
//       _ascending = ascending;
//       changed = true;
//     }
//     if (changed) {
//       _invalidateCache();
//       notifyListeners();
//     }
//   }

//   /// Helper to invalidate cached list
//   void _invalidateCache() {
//     _cachedTasks = null;
//   }

//   /// Optional: Bulk operations with single notify
//   Future<void> performBatch(Future<void> Function() operations) async {
//     bool shouldNotify = false;
//     try {
//       // Temporarily suppress notifications
//       await operations();
//       shouldNotify = true;
//     } finally {
//       if (shouldNotify) {
//         _invalidateCache();
//         notifyListeners();
//       }
//     }
//   }
// }

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/task_database.dart';
import '../utils/priority.dart';
import '../models/task_filter.dart'; // ← ADD THIS LINE

class TaskProvider extends ChangeNotifier {
  final TaskDatabase db;
  final _uuid = Uuid();

  // Raw tasks from database (updated automatically via stream)
  List<Task> _tasks = [];

  // Filters & sorting
  TaskFilter _filter = const TaskFilter();
  SortBy _sortBy = SortBy.createdAt;
  bool _ascending = false;

  // Stream subscription
  StreamSubscription<List<Task>>? _subscription;

  List<Task> get tasks {
    var list = List<Task>.from(_tasks);

    // === Filtering ===
    final query = _filter.searchQuery.trim().toLowerCase();
    final hasSearch = query.isNotEmpty;
    final now = DateTime.now();

    if (_filter.completed != null) {
      list = list.where((t) => t.isCompleted == _filter.completed).toList();
    }
    if (_filter.priority != null) {
      list = list.where((t) => t.priority == _filter.priority).toList();
    }
    if (_filter.overdueOnly) {
      list = list
          .where((t) =>
              t.dueDate != null && t.dueDate!.isBefore(now) && !t.isCompleted)
          .toList();
    }
    if (hasSearch) {
      list = list
          .where((t) =>
              t.title.toLowerCase().contains(query) ||
              (t.description ?? '').toLowerCase().contains(query) ||
              t.tags.any((tag) => tag.toLowerCase().contains(query)))
          .toList();
    }

    // === Sorting ===
    list.sort((a, b) {
      int cmp = 0;
      switch (_sortBy) {
        case SortBy.createdAt:
          cmp = a.createdAt.compareTo(b.createdAt);
          break;
        case SortBy.dueDate:
          final aDate = a.dueDate ?? DateTime(9999);
          final bDate = b.dueDate ?? DateTime(9999);
          cmp = aDate.compareTo(bDate);
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

  TaskProvider(this.db) {
    // Subscribe to database changes → auto-update _tasks → notify UI
    _subscription = db.watchAllTasks().listen((newTasks) {
      _tasks = newTasks;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // === CRUD Operations (super clean now!) ===

  Future<void> create({
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    List<String> tags = const [],
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      isCompleted: false,
      tags: tags,
    );

    await db.addTask(task);
    // No manual _tasks.add() or notifyListeners() → stream handles it!
  }

  Future<void> toggleComplete(Task task, bool value) async {
    final updated = task.copyWith(isCompleted: value);
    await db.updateTask(updated);
    // Stream will pick up the change and refresh UI automatically
  }

  Future<void> updateTask(Task updatedTask) async {
    await db.updateTask(updatedTask);
    // Auto-refresh via stream
  }

  Future<void> deleteTask(String id) async {
    await db.deleteTask(id);
    // Auto-refresh via stream
  }

  // === Filter & Sort ===

  void setFilter(TaskFilter newFilter) {
    if (_filter == newFilter) return;
    _filter = newFilter;
    notifyListeners();
  }

  void setSort(SortBy by, {bool? ascending}) {
    bool changed = _sortBy != by;
    _sortBy = by;

    if (ascending != null && _ascending != ascending) {
      _ascending = ascending;
      changed = true;
    }

    if (changed) notifyListeners();
  }
}
