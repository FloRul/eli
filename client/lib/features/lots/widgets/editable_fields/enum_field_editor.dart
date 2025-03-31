import 'package:flutter/material.dart';
import 'editable_field_base.dart';

/// An editable field for enum values
class EditableEnumField<T> extends EditableFieldBase<T> {
  /// List of all possible enum values
  final List<T> enumValues;
  
  /// Function to get the display name for an enum value
  final String Function(T value) getDisplayName;
  
  /// Optional color function for the enum values
  final Color Function(T value)? getColor;
  
  /// Optional icon function for the enum values
  final IconData Function(T value)? getIcon;

  const EditableEnumField({
    super.key,
    required super.value,
    required super.displayBuilder,
    required super.onUpdate,
    required this.enumValues,
    required this.getDisplayName,
    this.getColor,
    this.getIcon,
    super.label,
  });

  @override
  State<EditableEnumField<T>> createState() => _EditableEnumFieldState<T>();
}

class _EditableEnumFieldState<T> extends EditableFieldBaseState<T, EditableEnumField<T>> {
  @override
  void initializeController() {
    // No controllers needed for enum fields
  }
  
  @override
  void disposeController() {
    // No controllers to dispose
  }
  
  @override
  void updateControllerValue() {
    // No controller to update
  }
  
  @override
  void requestInitialFocus() {
    // No focus needed for enum fields
  }

  @override
  Widget buildEditorContent() {
    return _EnumEditorContent<T>(
      currentValue: _tempValue as T,
      enumValues: widget.enumValues,
      getDisplayName: widget.getDisplayName,
      getColor: widget.getColor,
      getIcon: widget.getIcon,
      label: widget.label,
      onValueChanged: (value) {
        setState(() {
          _tempValue = value;
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

/// Widget for enum editor content
class _EnumEditorContent<T> extends StatelessWidget {
  final T currentValue;
  final List<T> enumValues;
  final String Function(T value) getDisplayName;
  final Color Function(T value)? getColor;
  final IconData Function(T value)? getIcon;
  final String? label;
  final Function(T) onValueChanged;
  final Widget Function() actionsBuilder;

  const _EnumEditorContent({
    required this.currentValue,
    required this.enumValues,
    required this.getDisplayName,
    required this.onValueChanged,
    required this.actionsBuilder,
    this.getColor,
    this.getIcon,
    this.label,
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
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: enumValues.map((value) {
                final bool isSelected = value == currentValue;
                final Color? itemColor = getColor?.call(value);
                final IconData? itemIcon = getIcon?.call(value);
                
                return InkWell(
                  onTap: () => onValueChanged(value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      children: [
                        // Optional icon
                        if (itemIcon != null) ...[
                          Icon(
                            itemIcon, 
                            size: 16, 
                            color: itemColor,
                          ),
                          const SizedBox(width: 8),
                        ]
                        // Optional color indicator
                        else if (itemColor != null) ...[
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: itemColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        
                        // Display name
                        Expanded(
                          child: Text(
                            getDisplayName(value),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: itemColor,
                            ),
                          ),
                        ),
                        
                        // Selected indicator
                        if (isSelected)
                          Icon(
                            Icons.check, 
                            color: Theme.of(context).colorScheme.primary, 
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          actionsBuilder(),
        ],
      ),
    );
  }
}