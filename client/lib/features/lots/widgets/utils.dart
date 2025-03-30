import 'package:client/features/lots/models/enums.dart';
import 'package:flutter/material.dart';

/// Returns a color based on the lot status
Color getStatusColor(Status status) {
  switch (status) {
    case Status.critical:
      return Colors.red.shade700;
    case Status.closefollowuprequired:
      return Colors.orange.shade700;
    case Status.ongoing:
      return Colors.blue.shade700;
    case Status.onhold:
      return Colors.grey.shade600;
    case Status.completed:
      return Colors.green.shade700;
    case Status.unknown:
      return Colors.black;
  }
}

/// Returns a color based on the incoterm
Color getIncotermsColor(Incoterm incoterms) {
  String name = incoterms.name.toString().toLowerCase();
  if (name.contains('fob')) return Colors.purple.shade700;
  if (name.contains('cif')) return Colors.blue.shade700;
  if (name.contains('ex')) return Colors.teal.shade700;
  if (name.contains('dap')) return Colors.indigo.shade700;
  return Colors.blueGrey.shade700;
}

/// Extension method to handle alpha channel values
extension ColorExtension on Color {
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromRGBO(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.opacity,
    );
  }
}

/// A timeline entry with date, label and optional highlight
class TimelineEntry {
  final String label;
  final String date;
  final bool isHighlighted;
  final bool isPassed;

  TimelineEntry({
    required this.label,
    required this.date,
    this.isHighlighted = false,
    this.isPassed = false,
  });
}

/// A timeline widget that displays multiple dates in a vertical timeline
class DateTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final Color? primaryColor;

  const DateTimeline({
    super.key,
    required this.entries,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = primaryColor ?? colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        entries.length, 
        (index) => _buildTimelineItem(
          context, 
          entries[index], 
          isFirst: index == 0,
          isLast: index == entries.length - 1,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, 
    TimelineEntry entry, 
    {required bool isFirst, 
    required bool isLast,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Determine colors based on entry state
    final dotColor = entry.isHighlighted 
        ? color 
        : entry.isPassed 
            ? color.withOpacity(0.5) 
            : Colors.grey.shade400;
    
    final lineColor = entry.isPassed ? color.withOpacity(0.5) : Colors.grey.shade300;
    final textColor = entry.isHighlighted 
        ? color 
        : entry.isPassed 
            ? colorScheme.onSurface.withOpacity(0.9) 
            : colorScheme.onSurface.withOpacity(0.6);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Label
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 4.0),
            child: Text(
              entry.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: entry.isHighlighted ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        
        // Center - Timeline line and dot
        IntrinsicHeight(
          child: SizedBox(
            width: 30,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Vertical connecting line
                if (!isFirst || !isLast)
                  Positioned(
                    top: isFirst ? 20 : 0,
                    bottom: isLast ? 20 : 0,
                    left: 14,
                    width: 2,
                    child: Container(
                      color: lineColor,
                    ),
                  ),
                // Timeline dot
                Positioned(
                  left: 10,
                  top: 16,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Right side - Date
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: entry.isHighlighted
                  ? BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: color.withOpacity(0.3), width: 1),
                    )
                  : null,
              child: Text(
                entry.date,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: entry.isHighlighted ? FontWeight.bold : FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}