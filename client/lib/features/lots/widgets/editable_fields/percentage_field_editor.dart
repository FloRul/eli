import 'package:flutter/material.dart';
import 'number_field_editor.dart';

/// An editable field for percentage input (0-100)
class EditablePercentageField extends EditableNumberField {
  const EditablePercentageField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    super.label,
    super.hintText,
  }) : super(
    minValue: 0,
    maxValue: 100,
    suffixText: '%',
  );
  
  @override
  State<EditablePercentageField> createState() => _EditablePercentageFieldState();
}

class _EditablePercentageFieldState extends _EditableNumberFieldState {
  @override
  Widget buildEditorContent() {
    return _PercentageEditorContent(
      controller: _textController,
      focusNode: _focusNode,
      label: widget.label,
      hintText: widget.hintText,
      onSubmitted: (_) => saveChanges(),
      actionsBuilder: () => buildEditorActions(),
    );
  }
}

/// Widget for percentage editor content with a slider
class _PercentageEditorContent extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final String? hintText;
  final void Function(String)? onSubmitted;
  final Widget Function() actionsBuilder;

  const _PercentageEditorContent({
    required this.controller,
    required this.focusNode,
    required this.actionsBuilder,
    this.label,
    this.hintText,
    this.onSubmitted,
  });

  @override
  State<_PercentageEditorContent> createState() => _PercentageEditorContentState();
}

class _PercentageEditorContentState extends State<_PercentageEditorContent> {
  late double _sliderValue;
  
  @override
  void initState() {
    super.initState();
    _sliderValue = double.tryParse(widget.controller.text) ?? 0;
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.bodySmall),
            ),
          
          // Text field
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixText: '%',
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              isDense: true,
            ),
            onChanged: (value) {
              final doubleValue = double.tryParse(value) ?? 0;
              if (doubleValue > 100) {
                widget.controller.text = '100';
                widget.controller.selection = TextSelection.fromPosition(
                  const TextPosition(offset: 3),
                );
                setState(() {
                  _sliderValue = 100;
                });
              } else {
                setState(() {
                  _sliderValue = doubleValue;
                });
              }
            },
            onSubmitted: widget.onSubmitted,
          ),
          
          // Slider for percentage
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text('0%', style: Theme.of(context).textTheme.bodySmall),
                Expanded(
                  child: Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${_sliderValue.round()}%',
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        widget.controller.text = value.round().toString();
                      });
                    },
                  ),
                ),
                Text('100%', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          
          widget.actionsBuilder(),
        ],
      ),
    );
  }
}