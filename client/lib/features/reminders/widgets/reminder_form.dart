import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import hooks_riverpod
import 'package:intl/intl.dart';

// No longer need ReminderFormData class

class ReminderForm extends HookConsumerWidget {
  // Changed to HookConsumerWidget
  final int? initialProjectId;
  final int? initialLotId;
  // Updated callback signature
  final Future<void> Function({required String note, DateTime? dueDate, int? projectId, int? lotId}) onSubmit;
  final bool isSubmitting;

  const ReminderForm({
    super.key,
    this.initialProjectId,
    this.initialLotId,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use hooks for state management
    final formKey = useMemoized(() => GlobalKey<FormState>()); // Form key with hooks
    final noteController = useTextEditingController();
    final selectedDueDate = useState<DateTime?>(null); // useState for DateTime?
    // Initialize project/lot based on initial values passed to the widget
    final selectedProjectId = useState<int?>(initialProjectId);
    final selectedLotId = useState<int?>(initialProjectId != null ? initialLotId : null);

    // Effect to handle resetting lotId if projectId changes after initial build
    // (Handles cases where initialProjectId might be null then selected)
    useEffect(() {
      // If the project ID is cleared, clear the lot ID too.
      if (selectedProjectId.value == null) {
        selectedLotId.value = null;
      }
      // This effect depends on selectedProjectId.value
      return null; // No cleanup needed
    }, [selectedProjectId.value]);

    // Watch providers needed for dropdowns
    final projectsAsync = ref.watch(projectsProvider);
    // Watch lotsProvider only if a project is selected
    final lotsAsync = selectedProjectId.value != null ? ref.watch(lotsProvider(selectedProjectId.value!)) : null;


    return Form(
      key: formKey, // Use the hook-managed key
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: noteController, // Use hook controller
            decoration: const InputDecoration(labelText: 'Reminder Note *'),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a note' : null,
            enabled: !isSubmitting,
          ),
          const SizedBox(height: 16),
          // --- Due Date Picker ---
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedDueDate.value ==
                          null // Use hook value
                      ? 'No due date'
                      : 'Due: ${DateFormat.yMd().format(selectedDueDate.value!)}',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Select Due Date',
                onPressed:
                    isSubmitting
                        ? null
                        : () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate.value ?? DateTime.now(), // Use hook value
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (pickedDate != null) {
                            selectedDueDate.value = pickedDate; // Update hook state
                          }
                        },
              ),
              if (selectedDueDate.value != null) // Use hook value
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  tooltip: 'Clear Due Date',
                  onPressed: isSubmitting ? null : () => selectedDueDate.value = null, // Update hook state
                ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Project Dropdown ---
          projectsAsync.when(
            data:
                (projects) => DropdownButtonFormField<int>(
                  value: selectedProjectId.value, // Use hook value
                  hint: const Text('Link to Project (Optional)'),
                  decoration: const InputDecoration(labelText: 'Project'),
                  items: [
                    const DropdownMenuItem<int>(value: null, child: Text('None')),
                    ...projects.map(
                      (p) => DropdownMenuItem<int>(value: p.$1, child: Text(p.$2, overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                  onChanged:
                      isSubmitting
                          ? null
                          : (value) {
                            selectedProjectId.value = value; // Update hook state
                            // Reset lotId when project changes (handled by useEffect now)
                            // selectedLotId.value = null;
                          },
                ),
            loading:
                () =>
                    const Row(children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Loading Projects...")]),
            error: (e, s) => Text('Error loading projects: $e'),
          ),
          const SizedBox(height: 16),

          // --- Lot Dropdown (depends on selected project) ---
          if (selectedProjectId.value != null && lotsAsync != null)
            lotsAsync.when(
              data:
                  (lots) => DropdownButtonFormField<int>(
                    value: selectedLotId.value, // Use hook value
                    hint: const Text('Link to Lot (Optional)'),
                    decoration: const InputDecoration(labelText: 'Lot'),
                    items: [
                      const DropdownMenuItem<int>(value: null, child: Text('None')),
                      ...lots.map(
                        (l) =>
                            DropdownMenuItem<int>(value: l.id, child: Text(l.title, overflow: TextOverflow.ellipsis)),
                      ),
                    ],
                    onChanged:
                        isSubmitting
                            ? null
                            : (value) {
                              selectedLotId.value = value; // Update hook state
                            },
                  ),
              loading:
                  () => const Row(children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Loading Lots...")]),
              error: (e, s) => Text('Error loading lots: $e'),
            )
          else if (selectedProjectId.value != null)
            const Row(children: [CircularProgressIndicator(), SizedBox(width: 8), Text("Loading Lots...")]),

          // --- Submit Button (Now potentially part of the form itself) ---
          // If the button remains external (in the Dialog), you need a way to call trySubmit.
          // Using a key passed in is one way. Exposing trySubmit via useImperativeHandle is another.
          // Easiest for this refactor: Assume the external button will call trySubmit via a key.
          // We need to expose `trySubmit` or trigger it. Let's pass the key IN.

          // --- Let's adjust: The form should ideally be self-contained ---
          // Add the submit button here if it makes sense for reusability.
          // If button MUST stay external (in Dialog), use useImperativeHandle or pass key.

          // Example: Adding submit button internally (simplifies triggering logic)
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: isSubmitting ? null : trySubmit,
          //   child: isSubmitting
          //       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          //       : const Text('Submit'), // Or pass button text
          // ),
        ],
      ),
    );
  }
}
