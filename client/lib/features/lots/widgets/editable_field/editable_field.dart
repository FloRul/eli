import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_state.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';

/// A wrapper widget that makes any content field editable with an overlay editor
class EditableField<T> extends StatefulWidget {
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
  /// For enumDropdown, keys are display names, values are enum values.
  /// For dropdown, keys are internal values (often strings), values are display strings.
  final Map<String, dynamic>? options;

  /// Optional hint text for text fields
  final String? hintText;

  /// Optional input formatters for text fields
  final List<TextInputFormatter>? inputFormatters;

  /// Optional minimum value for numeric fields (validation currently basic)
  final num? minValue;

  /// Optional maximum value for numeric fields (validation currently basic)
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
  State<EditableField<T>> createState() => EditableFieldState<T>();
}
