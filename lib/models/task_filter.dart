import '../utils/priority.dart';

class TaskFilter {
  final bool? completed; // null = all, true = completed, false = pending
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

  // Helpful for the "All" chip in UI
  bool get isDefault =>
      completed == null &&
      priority == null &&
      searchQuery.trim().isEmpty &&
      !overdueOnly;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskFilter &&
          runtimeType == other.runtimeType &&
          completed == other.completed &&
          priority == other.priority &&
          searchQuery == other.searchQuery &&
          overdueOnly == other.overdueOnly;

  @override
  int get hashCode =>
      completed.hashCode ^
      priority.hashCode ^
      searchQuery.hashCode ^
      overdueOnly.hashCode;
}
