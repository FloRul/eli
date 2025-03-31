/// Re-export all editable field widgets from the new location
/// This is provided for backward compatibility with existing code
export 'editable_fields/index.dart';

import 'package:client/features/lots/widgets/editable_fields/index.dart';
/// Backward compatibility for the original EditableField class
/// Use the specific typed editors from editable_fields/ for new code
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editable_fields/text_field_editor.dart';
import 'editable_fields/number_field_editor.dart';
import 'editable_fields/percentage_field_editor.dart';
import 'editable_fields/date_field_editor.dart';
import 'editable_fields/status_field_editor.dart';
import 'editable_fields/incoterm_field_editor.dart';
import 'package:client/features/lots/models/enums.dart';

/// A general-purpose editable field that adapts based on the field type
/// For new code, consider using the specific typed editors directly
class EditableField<T> extends StatelessWidget {
  /// The current value of the field
  final T value;
  
  /// Builder for the display widget when not editing
  final Widget Function(T value) displayBuilder;
  
  /// Optional field label displayed in edit mode
  final String? label;
  
  /// Callback when the value is updated
  final Future<void> Function(T newValue) onUpdate;
  
  /// Type of field to be edited
  final EditableFieldType fieldType;
  
  /// Optional map of options for dropdown or enum fields
  final Map<String, dynamic>? options;
  
  /// Optional hint text for text fields
  final String? hintText;
  
  /// Optional input formatters for text fields
  final List<TextInputFormatter>? inputFormatters;
  
  /// Optional minimum value for numeric fields
  final num? minValue;
  
  /// Optional maximum value for numeric fields
  final num? maxValue;
  
  const EditableField({
    super.key,
    required this.value,
    required this.displayBuilder,
    required this.onUpdate,
    required this.fieldType, 
    this.label,
    this.options,
    this.hintText,
    this.inputFormatters,
    this.minValue,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    // Select the appropriate editor widget based on field type
    switch (fieldType) {
      case EditableFieldType.text:
        return EditableTextField(
          value: value as String,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
          hintText: hintText,
          inputFormatters: inputFormatters,
        );
        
      case EditableFieldType.multiline:
        return EditableTextField(
          value: value as String,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
          hintText: hintText,
          multiline: true,
          maxLines: 5,
        );
        
      case EditableFieldType.number:
        return EditableNumberField(
          value: value as int,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
          hintText: hintText,
          minValue: minValue as int?,
          maxValue: maxValue as int?,
        );
        
      case EditableFieldType.percentage:
        return EditablePercentageField(
          value: value as int,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
          hintText: hintText,
        );
        
      case EditableFieldType.date:
        return EditableDateField(
          value: value as DateTime?,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
        );
        
      case EditableFieldType.status:
        return EditableStatusField(
          value: value as Status,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
        );
        
      case EditableFieldType.incoterm:
        return EditableIncotermField(
          value: value as Incoterm,
          displayBuilder: (v) => displayBuilder(v as T),
          onUpdate: (v) => onUpdate(v as T),
          label: label,
        );
        
      // For dropdown and enum dropdown, we'd need to handle them differently
      // since we need more information about the options
      case EditableFieldType.dropdown:
      case EditableFieldType.enumDropdown:
      default:
        return Text('Unsupported field type: $fieldType');
    }
  }
}