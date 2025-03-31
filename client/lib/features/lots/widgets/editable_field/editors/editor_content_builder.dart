import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/editable_field/editors/custom_list_editors.dart';
import 'package:client/features/lots/widgets/editable_field/editors/date_editor.dart';
import 'package:client/features/lots/widgets/editable_field/editors/dropdown_editor.dart';
import 'package:client/features/lots/widgets/editable_field/editors/number_editor.dart';
import 'package:client/features/lots/widgets/editable_field/editors/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildEditorContent({
  required BuildContext context,
  required EditableFieldType fieldType,
  required String? label,
  required String? hintText,
  required Map<String, dynamic>? options,
  required TextEditingController textController,
  required FocusNode focusNode,
  required dynamic tempValue,
  required List<TextInputFormatter>? inputFormatters,
  required num? minValue,
  required num? maxValue,
  required ValueChanged<dynamic> onTempValueChanged, // To update state in parent
  required VoidCallback onSave,
  required VoidCallback onCancel,
  required bool isSubmitting,
}) {
  switch (fieldType) {
    case EditableFieldType.text:
    case EditableFieldType.multiline:
      return buildTextEditor(
        context: context,
        label: label,
        textController: textController,
        focusNode: focusNode,
        hintText: hintText,
        inputFormatters: inputFormatters,
        multiline: fieldType == EditableFieldType.multiline,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.number:
      return buildNumberEditor(
        context: context,
        label: label,
        textController: textController,
        focusNode: focusNode,
        hintText: hintText,
        inputFormatters: inputFormatters,
        minValue: minValue,
        maxValue: maxValue,
        isDecimal: tempValue is double || tempValue is num, // Pass type info
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.percentage:
      return buildPercentageEditor(
        context: context,
        label: label,
        textController: textController,
        focusNode: focusNode,
        hintText: hintText,
        inputFormatters: inputFormatters,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.date:
      return buildDateEditor(
        context: context,
        label: label,
        tempValue: tempValue,
        onTempValueChanged: onTempValueChanged,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.dropdown:
      return buildDropdownEditor(
        context: context,
        label: label,
        options: options,
        tempValue: tempValue,
        onTempValueChanged: onTempValueChanged,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.enumDropdown:
      return buildEnumDropdownEditor(
        context: context,
        label: label,
        options: options,
        tempValue: tempValue,
        onTempValueChanged: onTempValueChanged,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.status:
      return buildStatusEditor(
        context: context,
        label: label,
        tempValue: tempValue,
        onTempValueChanged: onTempValueChanged,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
    case EditableFieldType.incoterm:
      return buildIncotermEditor(
        context: context,
        label: label,
        tempValue: tempValue,
        onTempValueChanged: onTempValueChanged,
        onSave: onSave,
        onCancel: onCancel,
        isSubmitting: isSubmitting,
      );
  }
}
