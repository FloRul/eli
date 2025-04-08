import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:client/features/reminders/widgets/reminder_form.dart';
import 'package:client/features/reminders/widgets/reminder_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReminderListScreen extends HookConsumerWidget {
  final int? projectId;
  final int? lotId;

  const ReminderListScreen({super.key, this.projectId, this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final includeCompleted = useState(false);

    final currentFilters = useMemoized(() {
      return ReminderFilters(projectId: projectId, lotId: lotId, includeCompleted: includeCompleted.value);
    }, [projectId, lotId, includeCompleted.value]);

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Show Completed'),
                Switch(
                  value: includeCompleted.value,
                  onChanged: (value) {
                    includeCompleted.value = value;
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Reminders',
                  onPressed: () {
                    ref.read(remindersNotifierProvider(currentFilters).notifier).refresh();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: remindersAsyncValue.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(includeCompleted.value ? 'No reminders found.' : 'No pending reminders found.'),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];

                return ReminderListItem(reminder: reminder, listFilters: currentFilters);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReminderDialog(context, ref, currentFilters, projectId, lotId);
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showReminderDialog(
    BuildContext context,
    WidgetRef ref,
    ReminderFilters listFiltersBeingViewed,
    int? contextProjectId,
    int? contextLotId,
  ) {
    showDialog(
      context: context,

      builder:
          (context) => ReminderFormDialog(
            listFiltersBeingViewed: listFiltersBeingViewed,

            initialProjectId: contextProjectId,
            initialLotId: contextLotId,
          ),
    );
  }
}

class ReminderFormDialog extends ConsumerStatefulWidget {
  final ReminderFilters listFiltersBeingViewed;
  final int? initialProjectId;
  final int? initialLotId;

  const ReminderFormDialog({
    super.key,
    required this.listFiltersBeingViewed,
    this.initialProjectId,
    this.initialLotId,
  });

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
