import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/features/lots/widgets/editable_field/editors/editor_actions.dart';

Widget buildTextEditor({
  required BuildContext context,
  required String? label,
  required TextEditingController textController,
  required FocusNode focusNode,
  required String? hintText,
  required List<TextInputFormatter>? inputFormatters,
  required bool multiline,
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
          maxLines: multiline ? 5 : 1,
          minLines: multiline ? 3 : 1,
          textInputAction: multiline ? TextInputAction.newline : TextInputAction.done,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
          ),
          inputFormatters: inputFormatters,
          onSubmitted: multiline ? null : (_) => onSave(),
        ),
        buildEditorActions(context: context, isSubmitting: isSubmitting, onCancel: onCancel, onSave: onSave),
      ],
    ),
  );
}
