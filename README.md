# TaskFlow — Modern Task Manager (Flutter)

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue)](https://flutter.dev)
[![Drift](https://img.shields.io/badge/Drift-SQLite-green)](https://drift.simonbinder.eu/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful, performant, offline-first task management app built with Flutter.

### Features
- Create, edit, complete, and delete tasks
- Due dates, priorities (High/Medium/Low), custom tags
- Powerful filtering: search, pending/completed, overdue, priority
- Sorting by creation, due date, or priority
- Full offline persistence with Drift (SQLite on mobile/desktop, IndexedDB on web)
- Responsive Material 3 design with custom bottom sheet editor
- Debounced search and smooth animations

### Tech Stack
- Flutter 3.19+
- State Management: Provider
- Local Database: Drift (cross-platform)
- UI: Material 3, Slivers, CustomScrollView

### Run Locally
```bash
git clone https://github.com/eddtn/task_manager_app.git
cd task-manager-flutter
flutter pub get
flutter run
