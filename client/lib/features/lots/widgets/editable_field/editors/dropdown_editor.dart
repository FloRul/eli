import 'package:flutter/material.dart';
import 'package:client/features/lots/widgets/editable_field/editors/editor_actions.dart';

Widget buildDropdownEditor({
  required BuildContext context,
  required String? label,
  required Map<String, dynamic>? options, // Expects Map<String, String>
  required tempValue, // Should be String? (the key)
  required ValueChanged<String?> onTempValueChanged, // Callback to update state
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
  if (options == null || options.isEmpty || options is! Map<String, String>) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        options is! Map<String, String> ? 'Invalid options format' : 'No options available',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  // Ensure _tempValue is a valid key, default if not
  final String? currentKey =
      (tempValue != null && options.containsKey(tempValue.toString()))
          ? tempValue.toString()
          : null; // Allow null selection

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
        DropdownButtonFormField<String>(
          value: currentKey,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
          ),
          items:
              options.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key, // The internal value (String key)
                  child: Text(entry.value.toString()), // The display value
                );
              }).toList(),
          onChanged: (String? newValue) {
            onTempValueChanged(newValue); // Update state via callback
          },
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}

Widget buildEnumDropdownEditor<E>({
  required BuildContext context,
  required String? label,
  required Map<String, dynamic>? options, // Expects Map<String, E>
  required tempValue, // Should be E?
  required ValueChanged<E?> onTempValueChanged, // Callback to update state
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
  if (options == null || options.isEmpty || options is! Map<String, E>) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        options is! Map<String, E> ? 'Invalid options format for Enum' : 'No options available',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  // Ensure _tempValue is one of the enum values provided in options.
  final E? currentValue =
      (tempValue != null && options.containsValue(tempValue))
          ? (tempValue as E)
          : null; // Allow null or provide a default: options.values.first;

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
        DropdownButtonFormField<E>(
          value: currentValue,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
          ),
          items:
              options.entries.map<DropdownMenuItem<E>>((entry) {
                return DropdownMenuItem<E>(
                  value: entry.value, // The actual enum value
                  child: Text(entry.key), // The display name
                );
              }).toList(),
          onChanged: (E? newValue) {
            onTempValueChanged(newValue); // Update state via callback
          },
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}
