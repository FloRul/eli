import 'package:client/features/reminders/models/reminder.dart'; // Assuming Reminder model path
import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:client/features/reminders/widgets/reminder_form.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReminderFormDialog extends ConsumerWidget {
  final ReminderFilters listFiltersBeingViewed;
  final Reminder? reminderToEdit; // Optional: Reminder being edited
  // initialProjectId/LotId are less critical if reminderToEdit is provided,
  // but can serve as defaults if creating a new reminder *from* a specific context.
  final int? initialProjectId;
  final int? initialLotId;

  const ReminderFormDialog({
    super.key,
    required this.listFiltersBeingViewed,
    this.reminderToEdit, // Make reminderToEdit optional
    this.initialProjectId,
    this.initialLotId,
  });

  // Submission logic now handles both add and edit
  Future<void> _submitReminder(
    BuildContext context,
    WidgetRef ref, {
    required String note,
    DateTime? dueDate,
    int? projectId,
    int? lotId,
  }) async {
    final notifier = ref.read(remindersNotifierProvider(listFiltersBeingViewed).notifier);
    final isEditing = reminderToEdit != null;

    try {
      if (isEditing) {
        await notifier.updateReminder(
          reminderToEdit!.copyWith(note: note, dueDate: dueDate, projectId: projectId, lotId: lotId),
        );
      } else {
        await notifier.addReminder(note: note, dueDate: dueDate, projectId: projectId, lotId: lotId);
      }

      final message = isEditing ? 'Reminder updated.' : 'Reminder added.';
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (context.mounted) {
        final message = isEditing ? 'Error updating reminder: $e' : 'Error adding reminder: $e';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        // Consider re-throwing if the form needs to know about the error
        // throw e; // Uncomment if the form should handle the error state beyond resetting loading
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = reminderToEdit != null;
    final title = isEditing ? 'Edit Reminder' : 'Add New Reminder';

    // Determine initial project/lot for the form. Prioritize reminderToEdit,
    // then passed initial values.
    final effectiveInitialProjectId = reminderToEdit?.projectId ?? initialProjectId;
    final effectiveInitialLotId =
        reminderToEdit?.lotId ?? (effectiveInitialProjectId == initialProjectId ? initialLotId : null);

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ReminderForm(
          // Pass existing reminder data for pre-filling the form
          initialReminderData: reminderToEdit,
          // Use effective initial IDs determined above
          initialProjectId: effectiveInitialProjectId,
          initialLotId: effectiveInitialLotId,
          // Pass the combined add/edit submission logic
          onSubmit:
              ({required String note, DateTime? dueDate, int? projectId, int? lotId}) =>
                  _submitReminder(context, ref, note: note, dueDate: dueDate, projectId: projectId, lotId: lotId),
        ),
      ),
      actions: <Widget>[
        // Add a Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Just close the dialog
          child: const Text('Cancel'),
        ),
        // The "Submit" / "Update" button is now inside the ReminderForm
      ],
    );
  }
}
