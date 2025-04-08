import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:client/features/reminders/widgets/reminder_form.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReminderFormDialog extends ConsumerStatefulWidget {
  final ReminderFilters listFiltersBeingViewed;
  final int? initialProjectId;
  final int? initialLotId;

  const ReminderFormDialog({super.key, required this.listFiltersBeingViewed, this.initialProjectId, this.initialLotId});

  @override
  ConsumerState<ReminderFormDialog> createState() => _AddReminderDialogContentState();
}

class _AddReminderDialogContentState extends ConsumerState<ReminderFormDialog> {
  bool _isLoading = false;

  final _formWidgetKey = GlobalKey<State>();

  Future<void> _submitReminder({required String note, DateTime? dueDate, int? projectId, int? lotId}) async {
    setState(() => _isLoading = true);
    final notifier = ref.read(remindersNotifierProvider(widget.listFiltersBeingViewed).notifier);

    try {
      await notifier.addReminder(note: note, dueDate: dueDate, projectId: projectId, lotId: lotId);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder added.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding reminder: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Reminder'),
      content: SingleChildScrollView(
        child: ReminderForm(
          key: _formWidgetKey,
          initialProjectId: widget.initialProjectId,
          initialLotId: widget.initialLotId,
          onSubmit: _submitReminder,
          isSubmitting: _isLoading,
        ),
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed:
              _isLoading
                  ? null
                  : () {
                    final formState = _formWidgetKey.currentState;
                    if (formState != null && formState is FormState) {
                      print("Submit button pressed - Form validation/submission needs to be triggered.");

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Form submission trigger logic needed.')));
                    }
                  },
          child:
              _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Add Reminder'),
        ),
      ],
    );
  }
}
