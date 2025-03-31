import 'package:flutter/material.dart';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/utils.dart';
import 'enum_field_editor.dart';

/// Specialized editor for Incoterm enum values
class EditableIncotermField extends EditableEnumField<Incoterm> {
  const EditableIncotermField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    super.label = 'Incoterms',
  }) : super(
    enumValues: Incoterm.values,
    getDisplayName: (incoterm) => incoterm.name.toUpperCase(),
    getColor: (incoterm) => getIncotermsColor(incoterm),
  );
}