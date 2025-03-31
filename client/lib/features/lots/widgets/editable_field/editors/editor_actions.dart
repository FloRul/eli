import 'package:flutter/material.dart';

Widget buildEditorActions({
  required BuildContext context,
  required bool isSubmitting,
  required VoidCallback onCancel,
  required VoidCallback onSave,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0, bottom: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isSubmitting ? null : onCancel,
          style: TextButton.styleFrom(
            foregroundColor:
                isSubmitting
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // Corrected withOpacity
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: isSubmitting ? null : onSave,
          style: TextButton.styleFrom(
            foregroundColor: isSubmitting ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
          ),
          child:
              isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : const Text('Save'),
        ),
      ],
    ),
  );
}
