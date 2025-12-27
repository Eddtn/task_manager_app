import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../models/task.dart';
import '../utils/priority.dart';

part 'task_database.g.dart'; // Will be generated

class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get priority => integer().map(const PriorityConverter())();
  BoolColumn get isCompleted => boolean()();
  TextColumn get tags => text().map(const TagsConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class PriorityConverter extends TypeConverter<Priority, int> {
  const PriorityConverter();
  @override
  Priority fromSql(int fromDb) => Priority.values[fromDb];
  @override
  int toSql(Priority value) => value.index;
}

class TagsConverter extends TypeConverter<List<String>, String> {
  const TagsConverter();
  @override
  List<String> fromSql(String fromDb) =>
      fromDb.isEmpty ? [] : fromDb.split('|||');
  @override
  String toSql(List<String> value) => value.join('|||');
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tasks.db'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [TasksTable])
class TaskDatabase extends _$TaskDatabase {
  TaskDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Convert Drift companion to your Task model
  Task _taskFromRow(TasksTableData row) {
    return Task(
      id: row.id,
      title: row.title,
      description: row.description,
      createdAt: row.createdAt,
      dueDate: row.dueDate,
      priority: row.priority,
      isCompleted: row.isCompleted,
      tags: row.tags,
    );
  }

  Future<List<Task>> getAllTasks() async {
    final rows = await select(tasksTable).get();
    return rows.map(_taskFromRow).toList();
  }

  Future<Task> addTask(Task task) async {
    await into(tasksTable).insert(task.toCompanion());
    return task;
  }

  Future<Task> updateTask(Task task) async {
    await update(tasksTable).replace(task.toCompanion());
    return task;
  }

  Future<void> deleteTask(String id) async {
    await (delete(tasksTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Task>> watchAllTasks() {
    return select(tasksTable).map(_taskFromRow).watch();
  }
}

extension TaskToCompanion on Task {
  TasksTableCompanion toCompanion() {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      createdAt: Value(createdAt),
      dueDate: Value(dueDate),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      tags: Value(tags),
    );
  }
}
