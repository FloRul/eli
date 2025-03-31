import 'dart:math'; // Added for max function
import 'package:flutter/rendering.dart';
import 'package:client/features/lots/widgets/utils.dart'; // Assuming these exist
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:client/features/lots/models/enums.dart'; // Assuming these exist

// Assuming Status and Incoterm enums and their helper functions exist
// enum Status { /* ... */ open, closed, pending } // Example
// extension StatusExt on Status { String get displayName => this.toString().split('.').last; } // Example
// Color getStatusColor(Status s) => Colors.blue; // Example
// enum Incoterm { /* ... */ fob, cif, exw } // Example
// Color getIncotermsColor(Incoterm i) => Colors.green; // Example
// extension ColorExt on Color { Color withValues({double? alpha, int? red, int? green, int? blue}) => Color.fromRGBO(red ?? this.red, green ?? this.green, blue ?? this.blue, alpha ?? this.opacity); } // Example
// Select all text helper
extension SelectAll on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}

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
  State<EditableField<T>> createState() => _EditableFieldState<T>();
}

class _EditableFieldState<T> extends State<EditableField<T>> {
  // State management
  bool _isEditing = false;
  bool _isSubmitting = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();

  // Controllers and values
  late dynamic _tempValue;
  late final TextEditingController _textController;
  late final FocusNode _focusNode; // Keep for text fields

  // Constants for overlay positioning
  static const double _overlayMaxHeight = 250.0;
  static const double _overlayVerticalMargin = 5.0;
  static const double _overlayMinWidth = 150.0;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.value;
    _textController = TextEditingController(text: _getDisplayText());
    _focusNode = FocusNode();
    // REMOVED: _focusNode.addListener(_onFocusChange); // Focus listener is removed
  }

  @override
  void didUpdateWidget(EditableField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isEditing) {
      _tempValue = widget.value;
      _textController.text = _getDisplayText();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _textController.dispose();
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  // REMOVED: _onFocusChange method - dismissal is now handled by TapRegion

  String _getDisplayText() {
    final value = _tempValue; // Use local variable for easier null checks
    if (value == null) return '';

    try {
      switch (widget.fieldType) {
        case EditableFieldType.text:
        case EditableFieldType.multiline:
          return value.toString();

        case EditableFieldType.number:
          return value.toString(); // Assuming T is num or int

        case EditableFieldType.date:
          if (value is DateTime) {
            return DateFormat('yyyy-MM-dd').format(value);
          }
          return '';

        case EditableFieldType.dropdown:
          // Find the display value from options using the internal value (_tempValue)
          if (widget.options != null) {
            final entry = widget.options!.entries.firstWhere(
              (e) => e.key == value.toString(), // Compare keys
              orElse: () => MapEntry('', ''),
            );
            return entry.value?.toString() ?? value.toString(); // Display value or fallback
          }
          return value.toString();

        case EditableFieldType.enumDropdown:
          // Find the display name (key) from options using the enum value (_tempValue)
          if (widget.options != null) {
            final entry = widget.options!.entries.firstWhere(
              (e) => e.value == value, // Compare enum values
              orElse: () => MapEntry('', value), // Fallback key is empty string
            );
            return entry.key; // Display name (key)
          }
          // Fallback for enums if options aren't provided correctly
          return value.toString().split('.').last;

        case EditableFieldType.percentage:
          return '$value%'; // Assuming T is num or int

        case EditableFieldType.status:
          return (value as Status).displayName; // Assuming T is Status

        case EditableFieldType.incoterm:
          return (value as Incoterm).name.toUpperCase(); // Assuming T is Incoterm
      }
    } catch (e) {
      // Handle potential type errors during display formatting
      debugPrint("Error formatting display text for value '$value': $e");
      return value.toString(); // Fallback
    }
  }

  void _showEditor() {
    if (_isEditing || !mounted) return;

    setState(() {
      _isEditing = true;
      _tempValue = widget.value; // Reset temp value on edit start
      _textController.text = _getDisplayText(); // Update text controller
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    // Request focus after the overlay is built (primarily for text fields)
    if (widget.fieldType == EditableFieldType.text ||
        widget.fieldType == EditableFieldType.multiline ||
        widget.fieldType == EditableFieldType.number ||
        widget.fieldType == EditableFieldType.percentage) {
      // Ensure focus request happens after the frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isEditing) {
          _focusNode.requestFocus();
          // For text fields, select all text for easy replacement
          _textController.selectAll();
        }
      });
    }
  }

  void _cancelEdit() {
    if (!mounted) return;
    _removeOverlay(); // Remove overlay first
    setState(() {
      _isEditing = false;
      // No need to reset temp value here, it's reset when _showEditor is called
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _saveChanges() async {
    if (_isSubmitting || !mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      dynamic valueToSave;

      // Convert the edited value to the correct type T
      switch (widget.fieldType) {
        case EditableFieldType.text:
        case EditableFieldType.multiline:
          // Assume T is String or compatible
          valueToSave = _textController.text;
          break;

        case EditableFieldType.number:
          // Assume T is int or double/num
          valueToSave = num.tryParse(_textController.text) ?? 0;
          // Add clamping if min/max are provided
          if (widget.minValue != null) valueToSave = max(widget.minValue!, valueToSave as num);
          if (widget.maxValue != null) valueToSave = min(widget.maxValue!, valueToSave as num);
          if (T == int) valueToSave = (valueToSave as num).round(); // Convert to int if T is int
          break;

        case EditableFieldType.date:
          // Assume T is DateTime?
          // _tempValue should already be DateTime if date picker was used
          if (_tempValue is DateTime) {
            valueToSave = _tempValue;
          } else {
            // Allow manual text input parsing as fallback? Risky.
            try {
              valueToSave = DateTime.parse(_textController.text);
            } catch (e) {
              debugPrint("Invalid date format entered: ${_textController.text}");
              valueToSave = widget.value; // Revert to original on parse error
            }
          }
          break;

        case EditableFieldType.percentage:
          // Assume T is int or double/num
          final text = _textController.text.replaceAll('%', '').trim();
          num value = num.tryParse(text) ?? 0;
          value = value.clamp(0, 100); // Clamp between 0 and 100
          if (T == int) {
            valueToSave = value.round(); // Convert to int if T is int
          } else {
            valueToSave = value;
          }
          break;

        // For dropdowns and custom types, _tempValue holds the selected value directly
        case EditableFieldType.dropdown:
        case EditableFieldType.enumDropdown:
        case EditableFieldType.status:
        case EditableFieldType.incoterm:
          valueToSave = _tempValue;
          break;
      }

      // Perform the update only if the value has changed
      if (valueToSave != widget.value) {
        // Ensure the value is castable to T before calling onUpdate
        // This relies on the logic above producing a compatible type.
        if (valueToSave is T) {
          await widget.onUpdate(valueToSave);
        } else if (valueToSave == null && null is T) {
          // Handle saving null if T is nullable
          await widget.onUpdate(null as T);
        } else {
          throw FormatException(
            "Converted value type (${valueToSave?.runtimeType}) is not assignable to expected type ($T)",
          );
        }
      }

      if (mounted) {
        _removeOverlay(); // Remove overlay on success
        setState(() {
          _isEditing = false;
          _isSubmitting = false;
        });
      }
    } catch (e, s) {
      debugPrint('Error updating field: $e\n$s');
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final targetSize = renderBox.size;
    // Get global position (relative to screen)
    final targetGlobalPosition = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate available space and decide position (below or above)
    final spaceBelow = screenHeight - targetGlobalPosition.dy - targetSize.height - _overlayVerticalMargin;
    final spaceAbove = targetGlobalPosition.dy - _overlayVerticalMargin;

    bool renderAbove = spaceBelow < _overlayMaxHeight && spaceAbove > spaceBelow;

    // Determine Alignment and Offset
    final Alignment targetAnchor = renderAbove ? Alignment.topLeft : Alignment.bottomLeft;
    final Alignment followerAnchor = renderAbove ? Alignment.bottomLeft : Alignment.topLeft;
    final Offset offset =
        renderAbove ? const Offset(0, -_overlayVerticalMargin) : Offset(0, targetSize.height + _overlayVerticalMargin);

    // Calculate width, ensuring it doesn't exceed screen width minus some margin
    final double calculatedWidth = max(_overlayMinWidth, targetSize.width);
    final double editorWidth = min(calculatedWidth, screenWidth - 20); // Leave 10px margin each side

    // Calculate horizontal offset if needed (e.g., if overlay is wider than screen)
    double horizontalOffset = 0;
    // Check if rendering at target's left edge goes off-screen left
    if (targetGlobalPosition.dx < 10) {
      horizontalOffset = 10 - targetGlobalPosition.dx;
    }
    // Check if rendering at target's left edge + width goes off-screen right
    else if (targetGlobalPosition.dx + editorWidth > screenWidth - 10) {
      horizontalOffset = (screenWidth - 10) - (targetGlobalPosition.dx + editorWidth);
    }

    final adjustedOffset = offset.translate(horizontalOffset, 0);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            // No specific left/top needed when using CompositedTransformFollower
            width: editorWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: adjustedOffset,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              child: TapRegion(
                // Use TapRegion for detecting taps outside
                onTapOutside: (event) {
                  if (_isEditing) {
                    _cancelEdit();
                  }
                },
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias, // Clip content to rounded border
                  child: ConstrainedBox(
                    // Limit max height
                    constraints: const BoxConstraints(maxHeight: _overlayMaxHeight),
                    child: SingleChildScrollView(
                      // Allow scrolling if content overflows
                      child: _buildEditorContent(),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildEditorContent() {
    // Wrap the specific editor builders with common padding/structure if needed
    // Or keep padding within each builder as originally done.
    // Example: return Padding(padding: const EdgeInsets.all(8.0), child: _buildSpecificEditor());
    // Based on original code, padding is inside each builder.

    switch (widget.fieldType) {
      case EditableFieldType.text:
      case EditableFieldType.multiline:
        return _buildTextEditor(multiline: widget.fieldType == EditableFieldType.multiline);

      case EditableFieldType.number:
        return _buildNumberEditor();

      case EditableFieldType.date:
        return _buildDateEditor();

      case EditableFieldType.percentage:
        return _buildPercentageEditor();

      case EditableFieldType.dropdown:
        return _buildDropdownEditor();

      case EditableFieldType.enumDropdown:
        return _buildEnumDropdownEditor();

      case EditableFieldType.status:
        return _buildStatusEditor();

      case EditableFieldType.incoterm:
        return _buildIncotermEditor();
    }
  }

  // --- Editor Builder Widgets ---
  // (Largely unchanged, but ensure they use _tempValue for state
  // and call setState appropriately for interactive elements like dropdowns/custom lists)

  Widget _buildTextEditor({bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Slightly more padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important for Column size
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          TextField(
            controller: _textController,
            focusNode: _focusNode, // Use focus node here
            maxLines: multiline ? 5 : 1,
            minLines: multiline ? 3 : 1,
            textInputAction: multiline ? TextInputAction.newline : TextInputAction.done,
            // Use onChanged to update _tempValue for potential real-time validation/formatting if needed
            onChanged: (value) {
              // If complex logic needed, update _tempValue here, but for basic text,
              // reading from controller in _saveChanges is sufficient.
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              isDense: true,
            ),
            inputFormatters: widget.inputFormatters,
            // Save on Done key press for single line
            onSubmitted: multiline ? null : (_) => _saveChanges(),
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildNumberEditor() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          TextField(
            controller: _textController,
            focusNode: _focusNode, // Use focus node here
            keyboardType: TextInputType.numberWithOptions(
              decimal: T == double || T == num,
            ), // Allow decimal for double/num
            decoration: InputDecoration(
              hintText: widget.hintText ?? "Enter number",
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              isDense: true,
            ),
            inputFormatters: [
              // Allow digits, optional decimal point (if T allows), optional negative sign
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              // Use the provided formatters AFTER the basic filtering
              ...?widget.inputFormatters,
            ],
            onSubmitted: (_) => _saveChanges(),
            // Optional: Add onChanged for real-time validation against min/max
            onChanged: (value) {
              // Basic validation example (can be expanded)
              final num? parsedValue = num.tryParse(value);
              if (parsedValue != null) {
                if (widget.minValue != null && parsedValue < widget.minValue!) {
                  /* Handle error state */
                }
                if (widget.maxValue != null && parsedValue > widget.maxValue!) {
                  /* Handle error state */
                }
              }
            },
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildDateEditor() {
    // Display format inside the picker button
    final displayFormat = DateFormat('MMM d, yyyy');
    String displayText = 'Select date';
    if (_tempValue != null && _tempValue is DateTime) {
      try {
        displayText = displayFormat.format(_tempValue as DateTime);
      } catch (e) {
        /* Handle formatting error if needed */
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          InkWell(
            onTap: _showDatePicker, // Keep internal method
            borderRadius: BorderRadius.circular(6),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                isDense: true,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(displayText), const Icon(Icons.calendar_today, size: 18)],
              ),
            ),
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  // Internal method to show date picker
  void _showDatePicker() async {
    // Unfocus any text field before showing dialog
    // FocusScope.of(context).unfocus();

    DateTime initialDate = DateTime.now();
    if (_tempValue is DateTime) {
      initialDate = _tempValue as DateTime;
    } else if (widget.value is DateTime) {
      // Fallback to original value if tempValue is somehow wrong type
      initialDate = widget.value as DateTime;
    }

    final firstDate = DateTime(2000);
    final lastDate = DateTime(2100);

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null && mounted) {
      setState(() {
        _tempValue = date;
        // Optional: Update text controller if it's used for display backup
        _textController.text = DateFormat('yyyy-MM-dd').format(date);
      });
      // Keep focus within the overlay if possible, or allow save
    }
  }

  Widget _buildPercentageEditor() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          TextField(
            controller: _textController,
            focusNode: _focusNode, // Use focus node
            keyboardType: const TextInputType.numberWithOptions(decimal: false), // Percentage usually integer
            decoration: InputDecoration(
              hintText: widget.hintText ?? '0-100',
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              isDense: true,
              suffixText: '%',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Only allow digits
              // Use a custom formatter or onChanged to enforce 0-100
              LengthLimitingTextInputFormatter(3), // Max 3 digits (for 100)
              ...?widget.inputFormatters, // Allow additional user formatters
            ],
            onChanged: (value) {
              // Enforce 0-100 range dynamically
              if (value.isNotEmpty) {
                final intValue = int.tryParse(value) ?? -1; // Use -1 to detect parse failure
                if (intValue > 100) {
                  _textController.text = '100';
                  _textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _textController.text.length),
                  );
                } else if (intValue < 0) {
                  // Handle parse error or negative sign if digitsOnly wasn't perfect
                  _textController.clear();
                }
              }
            },
            onSubmitted: (_) => _saveChanges(),
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildDropdownEditor() {
    // Expects options: Map<String, String> where key=internalValue, value=displayValue
    if (widget.options == null || widget.options!.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No options available'));
    }

    // Ensure _tempValue is a valid key, default if not
    final String? currentKey =
        (_tempValue != null && widget.options!.containsKey(_tempValue.toString()))
            ? _tempValue.toString()
            : null; // Allow null selection if desired, or fallback: widget.options!.keys.first;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          // Use DropdownButtonFormField for better integration with forms/layouts
          DropdownButtonFormField<String>(
            value: currentKey,
            isExpanded: true,
            // Remove default underline drawn by FormField
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), // Adjust padding
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              isDense: true,
            ),
            items:
                widget.options!.entries.map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key, // The internal value (String key)
                    child: Text(entry.value?.toString() ?? entry.key), // The display value
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _tempValue = newValue; // Store the internal value (key)
                // Optional: update text controller if needed elsewhere
                _textController.text = widget.options![newValue] ?? newValue ?? '';
              });
            },
            // Add focus node if needed for specific focus control, but often not required for dropdowns
            // focusNode: _focusNode,
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildEnumDropdownEditor<E>() {
    // Expects options: Map<String, E> where key=displayName, value=enumValue
    if (widget.options == null || widget.options!.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No options available'));
    }
    // Ensure _tempValue is one of the enum values provided in options.
    final E? currentValue =
        (_tempValue != null && widget.options!.containsValue(_tempValue))
            ? (_tempValue as E)
            : null; // Or provide a default like: widget.options!.values.first;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          DropdownButtonFormField<E>(
            value: currentValue,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              isDense: true,
            ),
            items:
                widget.options!.entries.map<DropdownMenuItem<E>>((entry) {
                  return DropdownMenuItem<E>(
                    value: entry.value as E, // The actual enum value
                    child: Text(entry.key), // The display name
                  );
                }).toList(),
            onChanged: (E? newValue) {
              setState(() {
                _tempValue = newValue; // Store the enum value
                // Optional: update text controller
                // Find the key (display name) corresponding to the newValue
                final key =
                    widget.options!.entries
                        .firstWhere(
                          (e) => e.value == newValue,
                          orElse: () => MapEntry(newValue.toString(), newValue), // Fallback display name
                        )
                        .key;
                _textController.text = key;
              });
            },
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildStatusEditor() {
    // Assumes Status enum and getStatusColor function exist
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          Material(
            // Wrap list in Material for ink splash consistency
            color: Theme.of(context).colorScheme.surface, // Use theme background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Column takes minimum space
              children:
                  Status.values.map((status) {
                    final bool isSelected = _tempValue == status;
                    final Color statusColor = getStatusColor(status); // Assuming this exists

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _tempValue = status;
                          _textController.text = status.displayName; // Update controller if needed
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(status.displayName)), // Assuming extension method
                            if (isSelected) Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 18),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildIncotermEditor() {
    // Assumes Incoterm enum and getIncotermsColor function exist
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
            ),
          Material(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  Incoterm.values.map((incoterm) {
                    final bool isSelected = _tempValue == incoterm;
                    final Color incotermColor = getIncotermsColor(incoterm); // Assuming this exists

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _tempValue = incoterm;
                          _textController.text = incoterm.name.toUpperCase(); // Update controller
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align check icon to the right
                          children: [
                            Container(
                              // Incoterm "Chip"
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                // Assuming ColorExt exists:
                                color: incotermColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: incotermColor.withValues(alpha: 0.3), width: 1),
                              ),
                              child: Text(
                                incoterm.name.toUpperCase(),
                                style: TextStyle(color: incotermColor, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // const SizedBox(width: 8), // Remove fixed space
                            if (isSelected) Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 18),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          _buildEditorActions(),
        ],
      ),
    );
  }

  Widget _buildEditorActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0, bottom: 4.0), // Adjust padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isSubmitting ? null : _cancelEdit,
            style: TextButton.styleFrom(
              foregroundColor:
                  _isSubmitting
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _isSubmitting ? null : _saveChanges,
            style: TextButton.styleFrom(
              foregroundColor: _isSubmitting ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
            ),
            child:
                _isSubmitting
                    ? const SizedBox(
                      width: 18, // Match text size
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                    : const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a subtle hover effect to indicate editability
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Show click cursor on hover
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          key: _fieldKey,
          onTap: _isEditing ? null : _showEditor, // Only trigger showEditor if not already editing
          child: Container(
            // Add padding for tap target and visual spacing
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            // Optional: Add subtle background/border on hover? (Needs StatefulWidget)
            decoration: BoxDecoration(
              // Transparent border to maintain size consistently
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(4),
              // Example subtle hover background (requires state management for hover)
              // color: _isHovering ? Colors.grey.withOpacity(0.1) : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Row takes minimum horizontal space
              crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
              children: [
                Flexible(
                  // Ensure displayBuilder content doesn't overflow
                  child: widget.displayBuilder(widget.value),
                ),
                const SizedBox(width: 6), // Space before icon
                Icon(
                  Icons.edit_square, // A slightly different icon?
                  size: 14,
                  // Use a less prominent color, maybe slightly visible always
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Enum to determine the type of field being edited
enum EditableFieldType {
  text,
  multiline,
  number, // Can be int or double/num
  date, // Expects DateTime
  percentage, // Expects int or double/num (0-100)
  dropdown, // Expects Map<String, String> in options (internalValue -> displayValue)
  enumDropdown, // Expects Map<String, Enum> in options (displayName -> enumValue)
  status, // Expects Status enum, uses custom list builder
  incoterm, // Expects Incoterm enum, uses custom list builder
}

// --- Helper Extensions/Functions (Assumed to exist elsewhere) ---
// You would need these defined in your project:
/*
// In your enums file or utils:
enum Status { open, inProgress, closed }
extension StatusExtension on Status {
  String get displayName {
    switch (this) {
      case Status.open: return 'Open';
      case Status.inProgress: return 'In Progress';
      case Status.closed: return 'Closed';
      default: return toString().split('.').last;
    }
  }
}

Color getStatusColor(Status status) {
  switch (status) {
    case Status.open: return Colors.blue;
    case Status.inProgress: return Colors.orange;
    case Status.closed: return Colors.grey;
    default: return Colors.black;
  }
}

enum Incoterm { exw, fca, fob, cif, dap, ddp } // Example Incoterms

Color getIncotermsColor(Incoterm incoterm) {
 // Provide distinct colors for Incoterms
 switch (incoterm) {
     case Incoterm.exw: return Colors.purple;
     case Incoterm.fca: return Colors.teal;
     case Incoterm.fob: return Colors.indigo;
     case Incoterm.cif: return Colors.red;
     case Incoterm.dap: return Colors.amber;
     case Incoterm.ddp: return Colors.cyan;
     default: return Colors.brown;
 }
}

// Utility extension for modifying Color properties easily
extension ColorExt on Color {
  Color withValues({double? alpha, int? red, int? green, int? blue}) {
    return Color.fromRGBO(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.opacity,
    );
  }
}
*/
