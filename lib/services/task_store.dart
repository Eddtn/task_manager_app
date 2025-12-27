// import 'package:hive/hive.dart';
// import '../models/task.dart';

// class TaskStore {
//   static const String boxName = 'tasks_box';
//   late Box<Task> _box;

//   Future<void> init() async {
//     if (!Hive.isAdapterRegistered(1)) {
//       Hive.registerAdapter(TaskAdapter());
//     }
//     _box = await Hive.openBox<Task>(boxName);
//   }

//   List<Task> getAll() => _box.values.toList();

//   Future<void> add(Task task) async {
//     await _box.put(task.id, task);
//   }

//   Future<void> update(Task task) async {
//     await _box.put(task.id, task);
//   }

//   Future<void> delete(String id) async {
//     await _box.delete(id);
//   }

//   Future<void> clear() async {
//     await _box.clear();
//   }
// }

import '../models/task.dart';
import 'task_database.dart';

class TaskStore {
  final TaskDatabase db;

  TaskStore(this.db);

  Future<List<Task>> getAll() => db.getAllTasks();

  Future<void> add(Task task) => db.addTask(task);

  Future<void> update(Task task) => db.updateTask(task);

  Future<void> delete(String id) => db.deleteTask(id);
}
