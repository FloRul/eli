import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:client/features/reminders/screens/reminder_form_dialog.dart';
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
          showReminderDialog(context, currentFilters, projectId, lotId);
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void showReminderDialog(
  BuildContext context,
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
