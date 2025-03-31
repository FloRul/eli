import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/features/lots/widgets/editable_field/editors/editor_actions.dart';

Widget buildNumberEditor({
  required BuildContext context,
  required String? label,
  required TextEditingController textController,
  required FocusNode focusNode,
  required String? hintText,
  required List<TextInputFormatter>? inputFormatters,
  required num? minValue,
  required num? maxValue,
  required bool isDecimal, // To control keyboard type
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
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
        TextField(
          controller: textController,
          focusNode: focusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
          decoration: InputDecoration(
            hintText: hintText ?? "Enter number",
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
          ),
          inputFormatters: [
            // Allow digits, optional decimal point (if allowed), optional negative sign
            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
            // Use the provided formatters AFTER the basic filtering
            ...?inputFormatters,
          ],
          onSubmitted: (_) => onSave(),
          // Optional: Add onChanged for real-time validation against min/max
          onChanged: (value) {
            // Basic validation example (can be expanded)
            final num? parsedValue = num.tryParse(value);
            if (parsedValue != null) {
              // Consider adding visual feedback for validation errors
              if (minValue != null && parsedValue < minValue) {
                // Handle error state (e.g., change border color)
              }
              if (maxValue != null && parsedValue > maxValue) {
                // Handle error state
              }
            }
          },
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}

Widget buildPercentageEditor({
  required BuildContext context,
  required String? label,
  required TextEditingController textController,
  required FocusNode focusNode,
  required String? hintText,
  required List<TextInputFormatter>? inputFormatters,
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
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
        TextField(
          controller: textController,
          focusNode: focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          decoration: InputDecoration(
            hintText: hintText ?? '0-100',
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
            suffixText: '%',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
            ...?inputFormatters,
          ],
          onChanged: (value) {
            // Enforce 0-100 range dynamically
            if (value.isNotEmpty) {
              final intValue = int.tryParse(value) ?? -1;
              if (intValue > 100) {
                textController.text = '100';
                textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
              } else if (intValue < 0) {
                textController.clear();
              }
            }
          },
          onSubmitted: (_) => onSave(),
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}
