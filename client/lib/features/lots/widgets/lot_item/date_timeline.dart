import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package for robust date parsing/formatting
import 'package:client/features/lots/models/timeline_entry.dart'; // Assuming this path is correct

// Callback type remains the same
typedef DateUpdateCallback = void Function(TimelineEntry entry, DateTime newDate);

/// A timeline widget that displays multiple dates in a vertical timeline,
/// automatically sorts them, indicates today's date, and allows editing
/// dates via a date picker if a callback is provided.
class DateTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final Color? primaryColor;
  final DateUpdateCallback? onDateUpdate; // Callback for date changes

  const DateTimeline({super.key, required this.entries, this.primaryColor, this.onDateUpdate});

  // Helper function to parse dates safely
  // Returns null if parsing fails
  DateTime? _parseDate(String dateString) {
    try {
      // First, try ISO 8601 format (YYYY-MM-DD), common and unambiguous
      return DateTime.tryParse(dateString);
    } catch (_) {
      // Add other formats if needed, using intl
      // Example: return DateFormat('dd MMM yyyy').tryParse(dateString);
      print("Warning: Could not parse date '$dateString'. Assuming far future for sorting.");
      // Return a very future date for sorting unparseable items to the end,
      // or null if you prefer to handle it differently.
      return DateTime(9999);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = primaryColor ?? colorScheme.primary;

    // --- 1. Automatic Sorting ---
    final sortedEntries = List<TimelineEntry>.from(entries);
    sortedEntries.sort((a, b) {
      final dateA = _parseDate(a.date);
      final dateB = _parseDate(b.date);

      // Handle potential parsing errors (null dates)
      if (dateA == null && dateB == null) return 0; // Keep original relative order if both fail
      if (dateA == null) return 1; // Place entries with unparseable dates at the end
      if (dateB == null) return -1; // Place entries with unparseable dates at the end

      return dateA.compareTo(dateB);
    });
    // --- End Sorting ---

    // --- 2. Find Today's Position ---
    final now = DateTime.now();
    // Normalize 'today' to midnight for accurate date-only comparison
    final today = DateTime(now.year, now.month, now.day);
    int todayIndicatorIndex = -1; // Index *after* which to insert the indicator

    for (int i = 0; i < sortedEntries.length; i++) {
      final entryDate = _parseDate(sortedEntries[i].date);
      if (entryDate != null && !entryDate.isAfter(today)) {
        // This entry is on or before today. Indicator might go after this one.
        todayIndicatorIndex = i;
      } else {
        // This entry is after today. If we haven't found a spot yet,
        // it means today is before the first entry.
        if (todayIndicatorIndex == -1) {
          todayIndicatorIndex = -2; // Special value meaning "before the first item"
        }
        break; // Stop searching once we pass today's date
      }
    }
    // If loop finishes and indicatorIndex is still the initial -1,
    // it means today is before all items (handled by the -2 case above).
    // If it's sortedEntries.length - 1, it means today is after the last item.

    // --- Build Widgets with Indicator ---
    List<Widget> children = [];

    // Add indicator *before* all items if needed
    if (todayIndicatorIndex == -2) {
      children.add(_buildTodayIndicator(context, color));
    }

    for (int i = 0; i < sortedEntries.length; i++) {
      children.add(
        _buildTimelineItem(
          context,
          sortedEntries[i],
          // isFirst/isLast determined by position in the sorted list
          isFirst: i == 0,
          isLast: i == sortedEntries.length - 1,
          color: color,
          onDateUpdate: onDateUpdate,
        ),
      );

      // Add indicator *after* the current item if it's the correct position
      if (i == todayIndicatorIndex) {
        children.add(_buildTodayIndicator(context, color));
      }
    }

    // Handle case where indicator should be after the very last item
    // (This check is implicitly covered if todayIndicatorIndex ends up being sortedEntries.length - 1)

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  // Widget builder for a single timeline item (mostly unchanged)
  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEntry entry, {
    required bool isFirst,
    required bool isLast,
    required Color color,
    required DateUpdateCallback? onDateUpdate,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors (consider basing isPassed/isHighlighted on parsed date vs today)
    final entryDate = _parseDate(entry.date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Example: Recalculate isPassed based on parsed date
    // You might want to pass the original isPassed/isHighlighted flags
    // or recalculate them based on the date comparison here.
    final bool isEffectivelyPassed = entryDate != null && entryDate.isBefore(today);
    // Keep original highlight or define new logic, e.g., highlight if it's today
    // final bool isEffectivelyHighlighted = entry.isHighlighted || (entryDate != null && entryDate.isAtSameMomentAs(today));
    final bool isEffectivelyHighlighted = entry.isHighlighted; // Using original for now

    final dotColor =
        isEffectivelyHighlighted
            ? color
            : isEffectivelyPassed
            ? color.withAlpha(128)
            : Colors.grey.shade400;

    final lineColor = isEffectivelyPassed ? color.withAlpha(128) : Colors.grey.shade300;
    final textColor =
        isEffectivelyHighlighted
            ? color
            : isEffectivelyPassed
            ? colorScheme.onSurface.withAlpha(230)
            : colorScheme.onSurface.withAlpha(153);

    // Date Picker Logic (unchanged from original)
    Future<void> selectDate() async {
      DateTime? initial = _parseDate(entry.date); // Use helper
      final now = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial ?? now,
        firstDate: DateTime(now.year - 5, now.month, now.day),
        lastDate: DateTime(now.year + 5, now.month, now.day),
      );

      if (picked != null && onDateUpdate != null) {
        onDateUpdate(entry, picked);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Label
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 4.0),
            child: Text(
              entry.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isEffectivelyHighlighted ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),

        // Center - Timeline line and dot
        SizedBox(
          width: 30,
          height: 36, // Adjusted height might be needed depending on indicator
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical connecting line (hide if it's the first or last, depending on indicator style)
              Positioned(
                top: 0,
                bottom: 0,
                left: 14,
                width: 2,
                child: Container(
                  // Conditional line drawing could be added if needed
                  // e.g., hide top half if isFirst, hide bottom half if isLast
                  color: lineColor,
                ),
              ),
              // Timeline dot
              Positioned(
                left: 10,
                top: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right side - Date
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: InkWell(
              onTap: onDateUpdate != null ? selectDate : null,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    isEffectivelyHighlighted
                        ? BoxDecoration(
                          color: color.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: color.withAlpha(77), width: 1),
                        )
                        : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      // Consider formatting the date string consistently here if needed
                      // e.g., using DateFormat('dd MMM yyyy').format(_parseDate(entry.date)!)
                      entry.date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isEffectivelyHighlighted ? FontWeight.bold : FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    // Optional: Add edit icon if editable
                    if (onDateUpdate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(Icons.edit_calendar_outlined, size: 16, color: textColor.withAlpha(180)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget builder for the "Today" indicator
  Widget _buildTodayIndicator(BuildContext context, Color primaryColor) {
    final textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor);

    // Mimics the structure of _buildTimelineItem for alignment
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
      children: [
        // Left side - Spacer to align with labels
        const Expanded(
          child: SizedBox.shrink(), // Takes up space but renders nothing
        ),

        // Center - Horizontal line marker
        SizedBox(
          width: 30,
          height: 20, // Adjust height as needed
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Horizontal line across the vertical timeline line space
              Positioned(
                left: 0, // Start from left edge
                right: 0, // Go to right edge
                top: 9, // Center vertically (height/2 - line thickness/2)
                child: Container(
                  height: 2,
                  color: primaryColor, // Use primary color for emphasis
                ),
              ),
            ],
          ),
        ),

        // Right side - "Today" label
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Today", // Add localization if needed
              style: textStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
