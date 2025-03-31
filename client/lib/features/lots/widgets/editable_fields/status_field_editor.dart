import 'package:flutter/material.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'enum_field_editor.dart';

/// Specialized editor for Status enum values
class EditableStatusField extends EditableEnumField<Status> {
  const EditableStatusField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    super.label = 'Status',
  }) : super(
    enumValues: Status.values,
    getDisplayName: (status) => status.displayName,
    getColor: (status) => getStatusColor(status),
  );
}