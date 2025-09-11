import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/priority.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dueStr = task.dueDate != null ? DateFormat.yMMMd().format(task.dueDate!) : 'No due date';
    final overdue = task.dueDate != null && task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted;

    Color priorityColor(Priority p, BuildContext ctx) {
      switch (p) {
        case Priority.low:
          return Colors.green;
        case Priority.medium:
          return Colors.orange;
        case Priority.high:
          return Theme.of(ctx).colorScheme.error;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onToggle,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor(task.priority, context).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priorityLabel(task.priority),
                style: TextStyle(color: priorityColor(task.priority, context), fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        subtitle: Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.event, size: 16),
                const SizedBox(width: 4),
                Text(
                  dueStr,
                  style: TextStyle(color: overdue ? Theme.of(context).colorScheme.error : null),
                ),
              ],
            ),
            ...task.tags.map((t) => Chip(label: Text(t), visualDensity: VisualDensity.compact)).toList(),
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text("• ${task.description!}", maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (ctx) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
