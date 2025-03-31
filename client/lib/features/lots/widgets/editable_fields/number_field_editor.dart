import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editable_field_base.dart';
import 'text_field_editor.dart';

/// An editable field for numeric input
class EditableNumberField extends EditableFieldBase<int> {
  /// Optional hint text for the number field
  final String? hintText;
  
  /// Minimum allowed value
  final int? minValue;
  
  /// Maximum allowed value
  final int? maxValue;
  
  /// Optional suffix text to display after the number
  final String? suffixText;

  const EditableNumberField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    super.label,
    this.hintText,
    this.minValue,
    this.maxValue,
    this.suffixText,
  });

  @override
  State<EditableNumberField> createState() => _EditableNumberFieldState();
}

class _EditableNumberFieldState extends EditableFieldBaseState<int, EditableNumberField> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initializeController() {
    _textController = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }
  
  @override
  void disposeController() {
    _textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }
  
  @override
  void updateControllerValue() {
    _textController.text = _tempValue?.toString() ?? '0';
  }
  
  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      cancelEdit();
    }
  }
  
  @override
  void requestInitialFocus() {
    _focusNode.requestFocus();
    _textController.selectAll();
  }

  @override
  Widget buildEditorContent() {
    return _NumberEditorContent(
      controller: _textController,
      focusNode: _focusNode,
      label: widget.label,
      hintText: widget.hintText,
      suffixText: widget.suffixText,
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      onSubmitted: (_) => saveChanges(),
      actionsBuilder: () => buildEditorActions(),
    );
  }
  
  @override
  dynamic prepareValueForSave() {
    return int.tryParse(_textController.text) ?? 0;
  }
}

/// Widget for number editor content to improve readability
class _NumberEditorContent extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final String? hintText;
  final String? suffixText;
  final int? minValue;
  final int? maxValue;
  final void Function(String)? onSubmitted;
  final Widget Function() actionsBuilder;

  const _NumberEditorContent({
    required this.controller,
    required this.focusNode,
    required this.actionsBuilder,
    this.label,
    this.hintText,
    this.suffixText,
    this.minValue,
    this.maxValue,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(label!, style: Theme.of(context).textTheme.bodySmall),
            ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              suffixText: suffixText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              isDense: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              if (maxValue != null)
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final value = int.tryParse(newValue.text);
                  if (value != null && value > maxValue!) {
                    return TextEditingValue(
                      text: maxValue.toString(),
                      selection: TextSelection.collapsed(offset: maxValue.toString().length),
                    );
                  }
                  return newValue;
                }),
            ],
            onSubmitted: onSubmitted,
            onChanged: (value) {
              if (value.isNotEmpty && maxValue != null) {
                final intValue = int.tryParse(value) ?? 0;
                if (intValue > maxValue!) {
                  controller.text = maxValue.toString();
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                }
              }
            },
          ),
          actionsBuilder(),
        ],
      ),
    );
  }
}