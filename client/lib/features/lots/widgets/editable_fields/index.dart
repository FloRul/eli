/// Export file for all editable field widgets
/// This allows consumers to import all widgets from a single path
export 'editable_field_base.dart';
export 'text_field_editor.dart';
export 'number_field_editor.dart';
export 'percentage_field_editor.dart';
export 'date_field_editor.dart';
export 'enum_field_editor.dart';
export 'status_field_editor.dart';
export 'incoterm_field_editor.dart';

/// Re-export the field type enum for convenience
enum EditableFieldType {
  text,
  multiline,
  number,
  date,
  percentage,
  dropdown,
  enumDropdown,
  status,
  incoterm,
}