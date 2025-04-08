import 'package:client/features/reminders/models/reminder.dart';
import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReminderListItem extends ConsumerWidget {
  final Reminder reminder;
  final ReminderFilters listFilters; // Receive filters from parent list

  const ReminderListItem({
    super.key,
    required this.reminder,
    required this.listFilters, // Require filters
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the notifier instance corresponding to the list's filters
    final notifier = ref.read(remindersNotifierProvider(listFilters).notifier);

    return ListTile(
      leading: Checkbox(
        value: reminder.isCompleted,
        onChanged: (bool? value) async {
          // Make async
          if (value != null) {
            try {
              // Call notifier method to update completion status
              await notifier.setCompletion(reminder.id, value);
              // No need for snackbar on success, list will rebuild
            } catch (e) {
              // Handle error (e.g., show snackbar)
              if (context.mounted) {
                // Check if widget is still in tree
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating reminder: $e')));
              }
            }
          }
        },
      ),
      title: Text(
        /* ... (same as before) ... */
        reminder.note ?? 'No description',
        style: TextStyle(
          decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
          color: reminder.isCompleted ? Colors.grey : null,
        ),
      ),
      subtitle: reminder.dueDate != null ? Text('Due: ${DateFormat.yMd().format(reminder.dueDate!)}') : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            tooltip: 'Edit Reminder',
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
            tooltip: 'Delete Reminder',
            onPressed: () async {
              // Make async
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Reminder?'),
                      content: const Text('Are you sure you want to delete this reminder?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                try {
                  // Call notifier delete method
                  await notifier.deleteReminder(reminder.id);
                  if (context.mounted) {
                    // Check mount status before showing snackbar
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Reminder deleted.'), duration: Duration(seconds: 1)));
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Check mount status
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting reminder: $e')));
                  }
                }
              }
            },
          ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to edit/view screen
      },
    );
  }
}
