import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/reminders/providers/reminders_providers.dart';
import 'package:client/features/reminders/widgets/reminder_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import hooks
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ReminderListScreen extends HookConsumerWidget {
  // Use HookConsumerWidget
  final int? projectId;
  final int? lotId;

  const ReminderListScreen({super.key, this.projectId, this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State for Filters ---
    // Use useState hook to manage the 'includeCompleted' filter locally
    final includeCompleted = useState(false);

    // --- Dynamic Filters Object ---
    // Create the filters object based on widget args and local state
    final currentFilters = useMemoized(() {
      // Use useMemoized to avoid recreating on every build
      return ReminderFilters(
        projectId: projectId,
        lotId: lotId,
        includeCompleted: includeCompleted.value, // Use the state value
      );
    }, [projectId, lotId, includeCompleted.value]); // Dependencies

    // --- Watch Notifier ---
    // Watch the provider using the dynamically created filters
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
          // Add filters below the AppBar
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
                    // Update the local state, which will rebuild the widget
                    // and cause the remindersNotifierProvider to be watched
                    // with the new filter value.
                    includeCompleted.value = value;
                  },
                ),
                IconButton(
                  // Keep refresh button
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
            // ... (same empty state handling with RefreshIndicator) ...
            return RefreshIndicator(
              onRefresh: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
              child: ListView(
                // Wrap in ListView for RefreshIndicator compatibility
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
          // ... (same list display with RefreshIndicator) ...
          return RefreshIndicator(
            onRefresh: () => ref.read(remindersNotifierProvider(currentFilters).notifier).refresh(),
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                // Pass the CURRENT filters down so list item knows which notifier instance to interact with
                return ReminderListItem(reminder: reminder, listFilters: currentFilters);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          // ... (same error handling) ...
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
          // Pass the *contextual* projectId and lotId from the screen to the dialog
          _showAddReminderDialog(context, ref, currentFilters, projectId, lotId);
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Updated Dialog Method ---
  // Need to modify this significantly to handle project/lot selection
  void _showAddReminderDialog(
    BuildContext context,
    WidgetRef ref,
    ReminderFilters listFiltersBeingViewed,
    int? contextProjectId,
    int? contextLotId,
  ) {
    showDialog(
      context: context,
      // Use a ConsumerStatefulBuilder for complex state within the dialog
      builder:
          (context) => AddReminderDialogContent(
            listFiltersBeingViewed: listFiltersBeingViewed,
            // Pass the screen's context IDs as initial values if needed
            initialProjectId: contextProjectId,
            initialLotId: contextLotId,
          ),
    );
  }
}

class AddReminderDialogContent extends ConsumerStatefulWidget {
  final ReminderFilters listFiltersBeingViewed; // Filters of the list that opened this dialog
  final int? initialProjectId;
  final int? initialLotId;

  const AddReminderDialogContent({
    super.key,
    required this.listFiltersBeingViewed,
    this.initialProjectId,
    this.initialLotId,
  });

  @override
  ConsumerState<AddReminderDialogContent> createState() => _AddReminderDialogContentState();
}

class _AddReminderDialogContentState extends ConsumerState<AddReminderDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  DateTime? _selectedDueDate;
  int? _selectedProjectId;
  int? _selectedLotId;
  bool _isLoading = false; // To disable button during submission

  @override
  void initState() {
    super.initState();
    // Initialize selections based on context passed from the screen
    _selectedProjectId = widget.initialProjectId;
    // Only pre-select lot if project is also pre-selected
    _selectedLotId = widget.initialProjectId != null ? widget.initialLotId : null;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final note = _noteController.text.trim();
      final notifier = ref.read(remindersNotifierProvider(widget.listFiltersBeingViewed).notifier);

      try {
        await notifier.addReminder(
          note: note,
          dueDate: _selectedDueDate,
          projectId: _selectedProjectId, // Use state value
          lotId: _selectedLotId, // Use state value
        );
        if (mounted) {
          Navigator.of(context).pop(); // Close dialog on success
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
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers needed for dropdowns
    final projectsAsync = ref.watch(projectsProvider);
    // Watch lotsProvider only if a project is selected
    final lotsAsync =
        _selectedProjectId != null
            ? ref.watch(lotsProvider(_selectedProjectId!))
            : null; // Use null or AsyncValue.data([]) if no project selected

    return AlertDialog(
      title: const Text('Add New Reminder'),
      content: SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Reminder Note *'),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a note' : null,
              ),
              const SizedBox(height: 16),
              // --- Due Date Picker ---
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDueDate == null ? 'No due date' : 'Due: ${DateFormat.yMd().format(_selectedDueDate!)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    tooltip: 'Select Due Date',
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        /* ... */
                        context: context,
                        initialDate: _selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (pickedDate != null) {
                        setState(() => _selectedDueDate = pickedDate);
                      }
                    },
                  ),
                  if (_selectedDueDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Clear Due Date',
                      onPressed: () => setState(() => _selectedDueDate = null),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Project Dropdown ---
              projectsAsync.when(
                data:
                    (projects) => DropdownButtonFormField<int>(
                      value: _selectedProjectId,
                      hint: const Text('Link to Project (Optional)'),
                      decoration: const InputDecoration(labelText: 'Project'),
                      items: [
                        const DropdownMenuItem<int>(value: null, child: Text('None')), // Optional "None"
                        ...projects.map(
                          (p) => DropdownMenuItem<int>(value: p.$1, child: Text(p.$2, overflow: TextOverflow.ellipsis)),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedProjectId = value;
                          _selectedLotId = null; // Reset lot if project changes
                        });
                      },
                    ),
                loading:
                    () => const Row(
                      children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Loading Projects...")],
                    ),
                error: (e, s) => Text('Error loading projects: $e'),
              ),
              const SizedBox(height: 16),

              // --- Lot Dropdown (depends on selected project) ---
              if (_selectedProjectId != null && lotsAsync != null) // Show only if project selected
                lotsAsync.when(
                  data:
                      (lots) => DropdownButtonFormField<int>(
                        value: _selectedLotId,
                        hint: const Text('Link to Lot (Optional)'),
                        decoration: const InputDecoration(labelText: 'Lot'),
                        items: [
                          const DropdownMenuItem<int>(value: null, child: Text('None')), // Optional "None"
                          ...lots.map(
                            (l) => DropdownMenuItem<int>(
                              value: l.id,
                              child: Text(l.title, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedLotId = value;
                          });
                        },
                      ),
                  loading:
                      () => const Row(
                        children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Loading Lots...")],
                      ),
                  error: (e, s) => Text('Error loading lots: $e'),
                )
              else if (_selectedProjectId != null) // Case where project is selected but lots are loading initially
                const Row(children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Loading Lots...")]),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          // Use ElevatedButton for primary action
          onPressed: _isLoading ? null : _submit, // Disable button when loading
          child:
              _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Add Reminder'),
        ),
      ],
    );
  }
}
