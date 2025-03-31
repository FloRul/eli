import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/features/lots/widgets/editable_field/editors/editor_actions.dart';

Widget buildDateEditor({
  required BuildContext context,
  required String? label,
  required tempValue, // Should be DateTime?
  required ValueChanged<DateTime?> onTempValueChanged, // Callback to update state
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
  final displayFormat = DateFormat('MMM d, yyyy'); // Corrected format
  String displayText = 'Select date';
  if (tempValue != null && tempValue is DateTime) {
    try {
      displayText = displayFormat.format(tempValue);
    } catch (e) {
      // Handle formatting error if needed
      displayText = 'Invalid Date';
    }
  }

  // Helper function to show the date picker
  Future<void> showDatePickerDialog(DateTime? initialValue) async {
    DateTime initialDate = DateTime.now();
    if (initialValue is DateTime) {
      initialDate = initialValue;
    }

    final firstDate = DateTime(2000);
    final lastDate = DateTime(2101); // Extended last date slightly

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      onTempValueChanged(date); // Use the callback to update the state
    }
  }

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
        InkWell(
          onTap: () => showDatePickerDialog(tempValue as DateTime?),
          borderRadius: BorderRadius.circular(6),
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              isDense: true,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(displayText), const Icon(Icons.calendar_today, size: 18)],
            ),
          ),
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}
