# Task Manager (Flutter • Provider + Hive)

A portfolio-ready task manager app with:
- Create, edit, delete tasks
- Priority, due dates, tags
- Search, filter, sort (status/priority/due)
- Local persistence via **Hive** (works on **Android, iOS, Web, Desktop**)
- Clean architecture with **Provider (ChangeNotifier)**

## Quick start

1. Create a new Flutter project (so you get platform folders):
   ```bash
   flutter create task_manager_flutter
   ```

2. Replace the generated `pubspec.yaml` and `lib/` with the ones in this zip.

3. Install deps & run:
   ```bash
   cd task_manager_flutter
   flutter pub get
   flutter run -d chrome   # or your device
   ```

## Notes
- Hive boxes are initialized in `main.dart`.
- Manual `TaskAdapter` (no codegen needed).
- For web, Hive uses IndexedDB automatically.
