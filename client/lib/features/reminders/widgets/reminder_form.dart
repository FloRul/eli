import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/reminders/models/reminder.dart'; // Assuming Reminder model path
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ReminderForm extends HookConsumerWidget {
  // Optional initial data for editing
  final Reminder? initialReminderData;
  // These are still useful for context when *creating* a new reminder
  // (e.g., clicking "add reminder" on a specific project page)
  // They are used by the Dialog to determine the *effective* initial IDs.
  final int? initialProjectId;
  final int? initialLotId;

  final Future<void> Function({required String note, DateTime? dueDate, int? projectId, int? lotId}) onSubmit;

  const ReminderForm({
    super.key,
    this.initialReminderData, // Used to pre-fill form
    this.initialProjectId, // Used for context if initialReminderData is null
    this.initialLotId, // Used for context if initialReminderData is null
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = initialReminderData != null;

    // --- Hooks for State ---
    final formKey = useMemoized(() => GlobalKey<FormState>());
    // Initialize controller with initial note data if editing
    final noteController = useTextEditingController(text: initialReminderData?.note ?? '');
    // Initialize state hooks with initial data if editing
    final selectedDueDate = useState<DateTime?>(initialReminderData?.dueDate);
    // Prioritize initialReminderData, then passed initialProjectId
    final selectedProjectId = useState<int?>(initialReminderData?.projectId ?? initialProjectId);
    // Prioritize initialReminderData, then passed initialLotId (if project matches)
    final selectedLotId = useState<int?>(
      initialReminderData?.lotId ?? (selectedProjectId.value == initialProjectId ? initialLotId : null),
    );

    final isSubmitting = useState(false);

    // --- Effects ---
    // Effect to reset lot selection if project becomes null
    // (Simplified logic: Only clear lot if project becomes null)
    useEffect(() {
      if (selectedProjectId.value == null) {
        selectedLotId.value = null; // Clear lot if project is cleared
      }
      // Optional Enhancement: Could also check if current selectedLotId is valid
      // within the newly selected project's lots, if lots are loaded.
      return null;
    }, [selectedProjectId.value]); // Rerun when project selection changes

    // --- Data Fetching ---
    final projectsAsync = ref.watch(projectsProvider);
    final lotsAsync = selectedProjectId.value != null ? ref.watch(lotsProvider(selectedProjectId.value!)) : null;

    // --- Submission Handler ---
    Future<void> trySubmit() async {
      if (formKey.currentState?.validate() ?? false) {
        isSubmitting.value = true;
        try {
          // Call the submission logic passed from the parent.
          // This logic (in the dialog) already knows if it's add or edit.
          await onSubmit(
            note: noteController.text.trim(),
            dueDate: selectedDueDate.value,
            projectId: selectedProjectId.value,
            lotId: selectedLotId.value,
          );
        } catch (e) {
          // Handle potential errors re-thrown by onSubmit if needed
          // print("Error during submission: $e");
          // Dialog already shows snackbar, usually no action needed here.
        } finally {
          // Ensure loading state is reset
          if (context.mounted) {
            isSubmitting.value = false;
          }
        }
      }
    }

    // --- Build UI ---
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Note Field ---
          TextFormField(
            controller: noteController,
            decoration: const InputDecoration(labelText: 'Reminder Note *'),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a note' : null,
            enabled: !isSubmitting.value,
          ),
          const SizedBox(height: 16),

          // --- Due Date Picker ---
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedDueDate.value == null
                      ? 'No due date'
                      : 'Due: ${DateFormat.yMd().format(selectedDueDate.value!)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Select Due Date',
                onPressed:
                    isSubmitting.value
                        ? null
                        : () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate.value ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (pickedDate != null) {
                            selectedDueDate.value = pickedDate;
                          }
                        },
              ),
              if (selectedDueDate.value != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  iconSize: 18,
                  tooltip: 'Clear Due Date',
                  onPressed: isSubmitting.value ? null : () => selectedDueDate.value = null,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Project Dropdown ---
          projectsAsync.when(
            data:
                (projects) => DropdownButtonFormField<int>(
                  value: selectedProjectId.value,
                  hint: const Text('Link to Project (Optional)'),
                  decoration: const InputDecoration(labelText: 'Project'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int>(value: null, child: Text('None')),
                    ...projects.map(
                      (p) => DropdownMenuItem<int>(
                        value: p.$1, // Assuming (int id, String name)
                        child: Text(p.$2, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged:
                      isSubmitting.value
                          ? null
                          : (value) {
                            selectedProjectId.value = value;
                            // Lot reset is handled by useEffect
                          },
                  // Ensure initial value exists in items list or handle appropriately
                  validator: (value) {
                    // Add validation if needed, e.g., ensure the selected project ID is still valid
                    return null;
                  },
                ),
            loading:
                () => const InputDecorator(
                  decoration: InputDecoration(labelText: 'Project'),
                  child: Row(
                    children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 16),
                      Text("Loading..."),
                    ],
                  ),
                ),
            error:
                (e, s) => InputDecorator(
                  decoration: const InputDecoration(labelText: 'Project', errorText: 'Error loading projects'),
                  child: Text('Error: $e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
          ),
          const SizedBox(height: 16),

          // --- Lot Dropdown ---
          if (selectedProjectId.value != null)
            lotsAsync?.when(
                  data: (lots) {
                    // Check if the currently selected lot ID is still valid for the loaded lots
                    // If not, reset it *after* the build phase.
                    final isValidLotSelected =
                        selectedLotId.value == null || lots.any((l) => l.id == selectedLotId.value);
                    if (!isValidLotSelected) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          selectedLotId.value = null; // Reset if invalid
                        }
                      });
                    }

                    return DropdownButtonFormField<int>(
                      value: isValidLotSelected ? selectedLotId.value : null, // Show null if selected value is invalid
                      hint: const Text('Link to Lot (Optional)'),
                      decoration: const InputDecoration(labelText: 'Lot'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<int>(value: null, child: Text('None')),
                        ...lots.map(
                          (l) => DropdownMenuItem<int>(
                            value: l.id, // Assuming Lot has id and title
                            child: Text(l.title, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                      onChanged:
                          isSubmitting.value
                              ? null
                              : (value) {
                                selectedLotId.value = value;
                              },
                    );
                  },
                  loading:
                      () => const InputDecorator(
                        decoration: InputDecoration(labelText: 'Lot'),
                        child: Row(
                          children: [
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 16),
                            Text("Loading..."),
                          ],
                        ),
                      ),
                  error:
                      (e, s) => InputDecorator(
                        decoration: const InputDecoration(labelText: 'Lot', errorText: 'Error loading lots'),
                        child: Text('Error: $e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ),
                ) ??
                InputDecorator(
                  // Shows loading state immediately when project is selected
                  decoration: const InputDecoration(labelText: 'Lot'),
                  child: Row(
                    children: [
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      const SizedBox(width: 16),
                      Text("Loading..."),
                    ],
                  ),
                )
          else
            const SizedBox.shrink(), // No project selected, don't show lot dropdown
          // --- Submit Button ---
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
            onPressed: isSubmitting.value ? null : trySubmit,
            child:
                isSubmitting.value
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                    // Change button text based on mode
                    : Text(isEditing ? 'Update Reminder' : 'Add Reminder'),
          ),
        ],
      ),
    );
  }
}
