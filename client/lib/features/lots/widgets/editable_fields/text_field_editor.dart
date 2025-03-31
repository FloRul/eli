import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editable_field_base.dart';

/// Extension to add selectAll functionality to text controllers
extension SelectAll on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}

/// An editable field for text input
class EditableTextField extends EditableFieldBase<String> {
  /// Optional hint text for the text field
  final String? hintText;
  
  /// Optional input formatters for the text field
  final List<TextInputFormatter>? inputFormatters;
  
  /// Whether the text field should support multiline input
  final bool multiline;
  
  /// Maximum number of lines to show in the editor
  final int? maxLines;
  
  /// Maximum characters allowed in the field
  final int? maxLength;

  const EditableTextField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    super.label,
    this.hintText,
    this.inputFormatters,
    this.multiline = false,
    this.maxLines,
    this.maxLength,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends EditableFieldBaseState<String, EditableTextField> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initializeController() {
    _textController = TextEditingController(text: widget.value);
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
    _textController.text = tempValue?.toString() ?? '';
  }
  
  void _onFocusChange() {
    if (!_focusNode.hasFocus && isEditing) {
      cancelEdit();
    }
  }
  
  @override
  void requestInitialFocus() {
    _focusNode.requestFocus();
    // Select all text when editor opens for easier editing
    _textController.selectAll();
  }

  @override
  Widget buildEditorContent() {
    return _TextEditorContent(
      controller: _textController,
      focusNode: _focusNode,
      label: widget.label,
      hintText: widget.hintText,
      multiline: widget.multiline,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      onSubmitted: widget.multiline ? null : (_) => saveChanges(),
      actionsBuilder: () => buildEditorActions(),
    );
  }
  
  @override
  dynamic prepareValueForSave() {
    return _textController.text;
  }
}

/// Widget for text editor content to improve readability
class _TextEditorContent extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final String? hintText;
  final bool multiline;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;
  final Widget Function() actionsBuilder;

  const _TextEditorContent({
    required this.controller,
    required this.focusNode,
    required this.actionsBuilder,
    this.label,
    this.hintText,
    this.multiline = false,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
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
            maxLines: multiline ? (maxLines ?? 5) : 1,
            maxLength: maxLength,
            textInputAction: multiline ? TextInputAction.newline : TextInputAction.done,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              isDense: true,
            ),
            inputFormatters: inputFormatters,
            onSubmitted: onSubmitted,
          ),
          actionsBuilder(),
        ],
      ),
    );
  }
}