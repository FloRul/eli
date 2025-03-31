import 'dart:math';
import 'package:client/features/lots/models/enums.dart';
import 'package:client/features/lots/widgets/editable_field.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_overlay.dart';
import 'package:client/features/lots/widgets/editable_field/editable_field_type.dart';
import 'package:client/features/lots/widgets/editable_field/editors/editor_content_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper extension (can be moved to a utils file if used elsewhere)
extension SelectAll on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}

class EditableFieldState<T> extends State<EditableField<T>> {
  // State management
  bool isEditing = false;
  bool isSubmitting = false;
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();
  final GlobalKey fieldKey = GlobalKey();

  // Controllers and values
  late dynamic tempValue;
  late final TextEditingController textController;
  late final FocusNode focusNode;

  // Constants for overlay positioning (can be moved to overlay file)
  static const double overlayMaxHeight = 250.0;
  static const double overlayVerticalMargin = 5.0;
  static const double overlayMinWidth = 150.0;

  @override
  void initState() {
    super.initState();
    tempValue = widget.value;
    textController = TextEditingController(text: _getDisplayText());
    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(EditableField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !isEditing) {
      tempValue = widget.value;
      textController.text = _getDisplayText();
    }
  }

  @override
  void dispose() {
    removeOverlay();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  String _getDisplayText() {
    final value = tempValue;
    if (value == null) return '';

    try {
      switch (widget.fieldType) {
        case EditableFieldType.text:
        case EditableFieldType.multiline:
          return value.toString();
        case EditableFieldType.number:
          return value.toString();
        case EditableFieldType.date:
          if (value is DateTime) {
            return DateFormat('yyyy-MM-dd').format(value);
          }
          return '';
        case EditableFieldType.dropdown:
          if (widget.options != null) {
            final entry = widget.options!.entries.firstWhere(
              (e) => e.key == value.toString(),
              orElse: () => MapEntry('', ''),
            );
            return entry.value?.toString() ?? value.toString();
          }
          return value.toString();
        case EditableFieldType.enumDropdown:
          if (widget.options != null) {
            final entry = widget.options!.entries.firstWhere(
              (e) => e.value == value,
              orElse: () => MapEntry('', value),
            );
            return entry.key;
          }
          return value.toString().split('.').last;
        case EditableFieldType.percentage:
          return '$value%';
        case EditableFieldType.status:
          return (value as Status).displayName;
        case EditableFieldType.incoterm:
          return (value as Incoterm).name.toUpperCase();
      }
    } catch (e) {
      debugPrint("Error formatting display text for value '$value': $e");
      return value.toString();
    }
  }

  void showEditor() {
    if (isEditing || !mounted) return;

    setState(() {
      isEditing = true;
      tempValue = widget.value;
      textController.text = _getDisplayText();
    });

    overlayEntry = createOverlayEntry(
      context: context,
      fieldKey: fieldKey,
      layerLink: layerLink,
      maxHeight: overlayMaxHeight,
      minWidth: overlayMinWidth,
      verticalMargin: overlayVerticalMargin,
      editorContentBuilder:
          () => buildEditorContent(
            context: context,
            fieldType: widget.fieldType,
            label: widget.label,
            hintText: widget.hintText,
            options: widget.options,
            textController: textController,
            focusNode: focusNode,
            tempValue: tempValue,
            inputFormatters: widget.inputFormatters,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            onTempValueChanged: (newValue) {
              // Callback for date/dropdowns
              setState(() {
                tempValue = newValue;
              });
            },
            onSave: saveChanges,
            onCancel: cancelEdit,
            isSubmitting: isSubmitting,
          ),
      onTapOutside: () {
        if (isEditing) {
          cancelEdit();
        }
      },
    );
    Overlay.of(context).insert(overlayEntry!);

    if (widget.fieldType == EditableFieldType.text ||
        widget.fieldType == EditableFieldType.multiline ||
        widget.fieldType == EditableFieldType.number ||
        widget.fieldType == EditableFieldType.percentage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && isEditing) {
          focusNode.requestFocus();
          textController.selectAll();
        }
      });
    }
  }

  void cancelEdit() {
    if (!mounted) return;
    removeOverlay();
    setState(() {
      isEditing = false;
    });
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Future<void> saveChanges() async {
    if (isSubmitting || !mounted) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      dynamic valueToSave;

      switch (widget.fieldType) {
        case EditableFieldType.text:
        case EditableFieldType.multiline:
          valueToSave = textController.text;
          break;
        case EditableFieldType.number:
          valueToSave = num.tryParse(textController.text) ?? 0;
          if (widget.minValue != null) valueToSave = max(widget.minValue!, valueToSave as num);
          if (widget.maxValue != null) valueToSave = min(widget.maxValue!, valueToSave as num);
          if (T == int) valueToSave = (valueToSave as num).round();
          break;
        case EditableFieldType.date:
          if (tempValue is DateTime) {
            valueToSave = tempValue;
          } else {
            try {
              valueToSave = DateTime.parse(textController.text);
            } catch (e) {
              debugPrint("Invalid date format entered: ${textController.text}");
              valueToSave = widget.value; // Revert
            }
          }
          break;
        case EditableFieldType.percentage:
          final text = textController.text.replaceAll('%', '').trim();
          num value = num.tryParse(text) ?? 0;
          value = value.clamp(0, 100);
          if (T == int) {
            valueToSave = value.round();
          } else {
            valueToSave = value;
          }
          break;
        case EditableFieldType.dropdown:
        case EditableFieldType.enumDropdown:
        case EditableFieldType.status:
        case EditableFieldType.incoterm:
          valueToSave = tempValue;
          break;
      }

      if (valueToSave != widget.value) {
        if (valueToSave is T) {
          await widget.onUpdate(valueToSave);
        } else if (valueToSave == null && null is T) {
          await widget.onUpdate(null as T);
        } else {
          throw FormatException(
            "Converted value type (${valueToSave?.runtimeType}) is not assignable to expected type ($T)",
          );
        }
      }

      if (mounted) {
        removeOverlay();
        setState(() {
          isEditing = false;
          isSubmitting = false;
        });
      }
    } catch (e, s) {
      debugPrint('Error updating field: $e\n$s');
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
        // Optionally cancel edit on error
        // cancelEdit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a subtle hover effect to indicate editability
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Show click cursor on hover
      child: CompositedTransformTarget(
        link: layerLink,
        child: GestureDetector(
          key: fieldKey,
          onTap: isEditing ? null : showEditor,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: widget.displayBuilder(widget.value)),
                const SizedBox(width: 6),
                Icon(
                  Icons.edit_square,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), // Corrected withOpacity
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
