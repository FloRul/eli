import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'editable_field_base.dart';

/// An editable field for date input
class EditableDateField extends EditableFieldBase<DateTime?> {
  /// First date that can be selected (default is 2000-01-01)
  final DateTime? firstDate;
  
  /// Last date that can be selected (default is 2100-12-31)
  final DateTime? lastDate;
  
  /// Date format to display (default is MMM d, yyyy)
  final DateFormat? dateFormat;
  
  /// Text to display when date is null
  final String emptyText;

  const EditableDateField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    super.label,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.emptyText = 'Select date',
  });

  @override
  State<EditableDateField> createState() => _EditableDateFieldState();
}

class _EditableDateFieldState extends EditableFieldBaseState<DateTime?, EditableDateField> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final DateFormat _dateFormat;

  @override
  void initializeController() {
    _dateFormat = widget.dateFormat ?? DateFormat('MMM d, yyyy');
    _textController = TextEditingController(
      text: widget.value != null ? _dateFormat.format(widget.value!) : widget.emptyText,
    );
    _focusNode = FocusNode();
  }
  
  @override
  void disposeController() {
    _textController.dispose();
    _focusNode.dispose();
  }
  
  @override
  void updateControllerValue() {
    if (_tempValue != null) {
      _textController.text = _dateFormat.format(_tempValue!);
    } else {
      _textController.text = widget.emptyText;
    }
  }
  
  @override
  void requestInitialFocus() {
    // We don't need to focus since we're showing a date picker
  }

  @override
  Widget buildEditorContent() {
    return _DateEditorContent(
      initialDate: _tempValue,
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
      dateFormat: _dateFormat,
      label: widget.label,
      emptyText: widget.emptyText,
      onDateSelected: (date) {
        setState(() {
          _tempValue = date;
          if (date != null) {
            _textController.text = _dateFormat.format(date);
          } else {
            _textController.text = widget.emptyText;
          }
        });
      },
      actionsBuilder: () => buildEditorActions(),
    );
  }
  
  @override
  dynamic prepareValueForSave() {
    return _tempValue;
  }
}

/// Widget for date editor content with date picker
class _DateEditorContent extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final String? label;
  final String emptyText;
  final Function(DateTime?) onDateSelected;
  final Widget Function() actionsBuilder;

  const _DateEditorContent({
    required this.dateFormat,
    required this.onDateSelected,
    required this.actionsBuilder,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.label,
    this.emptyText = 'Select date',
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
          
          // Date display and picker button
          InkWell(
            onTap: () => _showDatePicker(context),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                isDense: true,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      initialDate != null 
                        ? dateFormat.format(initialDate!)
                        : emptyText,
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 16),
                ],
              ),
            ),
          ),
          
          // Clear date option if date is selected
          if (initialDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: TextButton.icon(
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear date'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                onPressed: () => onDateSelected(null),
              ),
            ),
          
          actionsBuilder(),
        ],
      ),
    );
  }
  
  void _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (date != null) {
      onDateSelected(date);
    }
  }
}