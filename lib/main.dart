import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart'; // Remove if you don't use it

import 'services/task_database.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart'; // Adjust path if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the Drift database instance (this opens the connection)
  final db = TaskDatabase();

  runApp(
    DevicePreview(
      enabled: false, // Set to true only when testing different devices
      builder: (context) => TaskApp(db: db),
    ),
  );
}

class TaskApp extends StatelessWidget {
  final TaskDatabase db;

  const TaskApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Create ONE TaskProvider, passing the database directly
      create: (_) => TaskProvider(db),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        locale: DevicePreview.locale(context), // Works with DevicePreview
        builder: DevicePreview.appBuilder, // Works with DevicePreview
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
