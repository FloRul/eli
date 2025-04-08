import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:client/features/reminders/widgets/reminder_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart'; // For dialog date formatting

class ReminderListPage extends HookConsumerWidget {
  final int? projectId;
  final int? lotId;
  // Could add a state variable or provider to manage includeCompleted filter

  const ReminderListPage({super.key, this.projectId, this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create filter object - manage includeCompleted via local state or another provider if needed
    final currentFilters = ReminderFilters(
      projectId: projectId,
      lotId: lotId,
      includeCompleted: false, // Example: default to false
    );

    // Watch the Notifier provider with the current filters
    final remindersAsyncValue = ref.watch(remindersNotifierProvider(currentFilters));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectId != null
              ? 'Project Reminders'
              : lotId != null
              ? 'Lot Reminders'
              : 'My Reminders',
        ),
        actions: [
          // Optional: Add a refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Reminders',
            onPressed: () {
              // Call the refresh method on the notifier
              ref.read(remindersNotifierProvider(currentFilters).notifier).refresh();
            },
          ),
          // Optional: Add toggle for includeCompleted
        ],
      ),
      body: remindersAsyncValue.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return RefreshIndicator(
              // Allow pull-to-refresh
              onRefresh: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
              child: ListView(
                // Wrap in ListView for RefreshIndicator compatibility
                children: const [
                  Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No reminders found.'))),
                ],
              ),
            );
          }
          return RefreshIndicator(
            // Allow pull-to-refresh
            onRefresh: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                // Pass the filters down so list item knows which notifier instance to interact with
                return ReminderListItem(reminder: reminder, listFilters: currentFilters);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading reminders: $error'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReminderDialog(context, ref, currentFilters); // Pass filters to dialog
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Update dialog to call notifier method and pass filters
  void _showAddReminderDialog(BuildContext context, WidgetRef ref, ReminderFilters currentFilters) {
    final noteController = TextEditingController();
    DateTime? selectedDueDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Reminder'),
              content: Column(
                /* ... (content same as before) ... */
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'Reminder Note'),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDueDate == null ? 'No due date' : 'Due: ${DateFormat.yMd().format(selectedDueDate!)}',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        tooltip: 'Select Due Date',
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 365)), // Adjust range
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDueDate = pickedDate;
                            });
                          }
                        },
                      ),
                      if (selectedDueDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          tooltip: 'Clear Due Date',
                          onPressed: () => setDialogState(() => selectedDueDate = null),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () async {
                    // Make async
                    final note = noteController.text.trim();
                    if (note.isNotEmpty) {
                      // Read the notifier for the specific filter set
                      final notifier = ref.read(remindersNotifierProvider(currentFilters).notifier);
                      try {
                        // Call the notifier's add method
                        await notifier.addReminder(
                          note: note,
                          dueDate: selectedDueDate,
                          // Pass filters if they should dictate the new reminder's properties
                          // If projectId/lotId are context, they might come from currentFilters
                          projectId: currentFilters.projectId,
                          lotId: currentFilters.lotId,
                        );
                        Navigator.of(context).pop(); // Close dialog on success
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder added.')));
                      } catch (e) {
                        // Error is handled/rethrown by notifier, show feedback here
                        Navigator.of(context).pop(); // Close dialog on error too
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error adding reminder: $e')));
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
