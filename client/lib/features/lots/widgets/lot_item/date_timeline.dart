import 'package:flutter/material.dart';
import 'package:client/features/lots/models/timeline_entry.dart'; // Assuming path is correct
import 'package:intl/intl.dart';

// Callback type remains the same
typedef DateUpdateCallback = void Function(TimelineEntry entry, DateTime newDate);

class DateTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final DateUpdateCallback? onDateUpdate; // Callback for date changes
  final bool showTodayIndicator; // Option to hide indicator

  const DateTimeline({
    super.key,
    required this.entries,
    this.onDateUpdate,
    this.showTodayIndicator = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final todayDotColor = colorScheme.secondary; // Today color

    // --- 1. Automatic Sorting ---
    final sortedEntries = List<TimelineEntry>.from(entries);
    sortedEntries.sort((a, b) {
      // Keep nulls at the end during sort
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1; // Null dates go to the end
      if (b.date == null) return -1; // Null dates go to the end
      return a.date!.compareTo(b.date!);
    });
    // --- End Sorting ---

    // --- 2. Find Today's Position ---
    final now = DateTime.now();
    // Normalize 'today' to midnight for accurate date-only comparison
    final today = DateTime(now.year, now.month, now.day);
    int todayIndicatorIndex = -1; // Index *after* which to insert indicator

    if (showTodayIndicator) {
      // Only calculate if we need to show it
      for (int i = 0; i < sortedEntries.length; i++) {
        final entryDate = sortedEntries[i].date;
        // Check if entry date is not null and is on or before today
        if (entryDate != null && !entryDate.isAfter(today)) {
          todayIndicatorIndex = i;
        } else {
          // This entry is after today or is null.
          // If we haven't found a spot yet (still -1), today is before the first valid date.
          if (todayIndicatorIndex == -1) {
            todayIndicatorIndex = -2; // Special value: insert indicator before the first item
          }
          break; // Stop searching once we pass today's date
        }
      }
      // If loop finished and index is still -1, today is before all items (-2 handled)
      // or all items are null/before today. If it's equal to length -1, it's after the last item.
    }
    // --- End Today Finding ---

    // --- Build Widgets ---
    List<Widget> children = [];

    // A. Add indicator *before* all items if needed
    if (showTodayIndicator && todayIndicatorIndex == -2) {
      final bool isAlsoLast = sortedEntries.isEmpty; // Is it the only thing?
      // Determine color of the line segment below the indicator
      final Color nextItemLineColor =
          sortedEntries.isNotEmpty
              ? _getLineColor(sortedEntries[0], today, primaryColor, colorScheme)
              : Colors.grey.shade300; // Default if no items

      // Line above doesn't exist, color doesn't matter but provide something.
      final Color prevItemLineColor = todayDotColor;

      children.add(
        _buildTodayIndicator(
          context,
          todayDotColor,
          prevItemLineColor, // Color for line above (won't be drawn)
          nextItemLineColor, // Color for line below
          isFirstIndicator: true, // *** It is the first element ***
          isLastIndicator: isAlsoLast, // *** Is it also the last? ***
        ),
      );
    }

    // B. Add Timeline Items and potentially Today Indicator *between* items
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final bool isFirstItem = i == 0;
      final bool isLastItem = i == sortedEntries.length - 1;

      // Add the actual timeline item
      children.add(
        _buildTimelineItem(
          context,
          entry,
          isFirst: isFirstItem,
          isLast: isLastItem,
          primaryColor: primaryColor,
          onDateUpdate: onDateUpdate,
          today: today, // Pass today for internal checks
        ),
      );

      // Add indicator *after* the current item if needed
      if (showTodayIndicator && i == todayIndicatorIndex && todayIndicatorIndex != -2) {
        final bool isAlsoLast = isLastItem; // Is today after the very last item?

        // Line color above Today comes from the item we just added
        final Color prevItemLineColor = _getLineColor(entry, today, primaryColor, colorScheme);

        // Line color below Today (if it exists) comes from the next item
        final Color nextItemLineColor;
        if (isAlsoLast) {
          // No item below, line won't be drawn, provide default
          nextItemLineColor = todayDotColor;
        } else {
          // Use the status of the next item to determine the color below today
          nextItemLineColor = _getLineColor(sortedEntries[i + 1], today, primaryColor, colorScheme);
        }

        children.add(
          _buildTodayIndicator(
            context,
            todayDotColor,
            prevItemLineColor, // Color for line above
            nextItemLineColor, // Color for line below
            isFirstIndicator: false, // *** Not the first element ***
            isLastIndicator: isAlsoLast, // *** Is it the last element? ***
          ),
        );
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  // Helper to determine line color based on entry's date relative to today
  // Takes the entry, today's date, primary color, and color scheme for context
  Color _getLineColor(TimelineEntry entry, DateTime today, Color primaryColor, ColorScheme colorScheme) {
    final entryDate = entry.date;
    final bool isPast = entryDate != null && entryDate.isBefore(today);
    final bool isToday =
        entryDate != null &&
        entryDate.year == today.year &&
        entryDate.month == today.month &&
        entryDate.day == today.day;
    final bool isHighlighted = entry.isHighlighted;

    // Determine the line color logic:
    // - If the item itself is highlighted or is today:
    //   - Use faded primary if it's in the past or is today.
    //   - Use grey if it's highlighted but still in the future.
    // - If not highlighted and not today:
    //   - Use faded primary if it's in the past.
    //   - Use grey if it's in the future or has a null date.
    if (isHighlighted || isToday) {
      return isPast || isToday ? primaryColor.withAlpha(128) : Colors.grey.shade300;
    } else if (isPast) {
      return primaryColor.withAlpha(128);
    } else {
      // Future or null date
      return Colors.grey.shade300;
    }
  }

  // Builds a single row for a date entry in the timeline
  Widget _buildTimelineItem(
    BuildContext context,
    TimelineEntry entry, {
    required bool isFirst,
    required bool isLast,
    required Color primaryColor,
    required DateUpdateCallback? onDateUpdate,
    required DateTime today, // Pass today date for comparisons
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final entryDate = entry.date;

    // Determine state based on comparison with *today* (midnight)
    final bool isPast = entryDate != null && entryDate.isBefore(today);
    final bool isToday =
        entryDate != null &&
        entryDate.year == today.year &&
        entryDate.month == today.month &&
        entryDate.day == today.day;
    // Item is highlighted if explicitly set OR if its date is today
    final bool isEffectivelyHighlighted = entry.isHighlighted || isToday;

    // Determine Colors for dot and text
    final Color dotColor;
    final Color textColor;
    // Line color is determined using the helper function
    final Color lineColor = _getLineColor(entry, today, primaryColor, colorScheme);

    if (isEffectivelyHighlighted) {
      dotColor = primaryColor;
      textColor = primaryColor;
    } else if (isPast) {
      dotColor = primaryColor.withAlpha(128); // Faded primary dot for past items
      textColor = colorScheme.onSurface.withAlpha(230); // Slightly faded text
    } else {
      // Future or null date
      dotColor = Colors.grey.shade400; // Grey dot
      textColor = colorScheme.onSurface.withAlpha(153); // More faded text
    }

    // --- Date Picker Logic ---
    Future<void> selectDate() async {
      if (onDateUpdate == null) return; // No callback provided

      final now = DateTime.now();
      DateTime initial = entry.date ?? now; // Default to now if date is null
      final DateTime firstSelectable = DateTime(now.year - 5); // Allow selecting 5 years back
      final DateTime lastSelectable = DateTime(now.year + 5); // Allow selecting 5 years forward

      // Ensure initial date is within the selectable range
      if (initial.isBefore(firstSelectable)) initial = firstSelectable;
      if (initial.isAfter(lastSelectable)) initial = lastSelectable;

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: firstSelectable,
        lastDate: lastSelectable,
      );

      if (picked != null) {
        // Call the callback with the original entry object and the new date
        onDateUpdate(entry, picked);
      }
    }
    // --- End Date Picker ---

    // --- Constants for layout ---
    const double dotSize = 10.0;
    const double dotBorderSize = 1.5;
    const double verticalItemHeight = 36.0; // Height of the row for date entry
    const double lineHorizontalPosition = 14.0; // Center X of the line
    const double dotHorizontalPosition = 10.0; // Left edge of the dot
    const double dotVerticalPosition = (verticalItemHeight - dotSize) / 2; // Center Y of the dot

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align tops
      children: [
        // --- Left side - Label ---
        Expanded(
          child: Padding(
            // Adjust top padding to roughly align baseline of text with date
            padding: const EdgeInsets.only(top: 8.0, right: 4.0),
            child: Text(
              entry.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isEffectivelyHighlighted ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.right,
              maxLines: 2, // Allow wrapping if label is long
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // --- Center - Line and Dot ---
        SizedBox(
          width: 30, // Fixed width for the timeline graphic column
          height: verticalItemHeight, // Use constant height
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical Line Segment
              Positioned(
                // Start line below dot center if first, otherwise from top edge
                top: isFirst ? dotVerticalPosition + (dotSize / 2) : 0,
                // End line above dot center if last, otherwise at bottom edge
                bottom: isLast ? dotVerticalPosition + (dotSize / 2) : 0,
                left: lineHorizontalPosition, // Center the line horizontally
                width: 2, // Line thickness
                child: Container(color: lineColor), // Use the determined line color
              ),
              // Dot
              Positioned(
                left: dotHorizontalPosition, // Position dot horizontally
                top: dotVerticalPosition, // Position dot vertically centered
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: dotColor, // Use the determined dot color
                    shape: BoxShape.circle,
                    // White border creates a "punch-out" effect over the line
                    border: Border.all(color: Colors.white, width: dotBorderSize),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Right side - Date ---
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0), // Match label padding
            child: InkWell(
              // Only enable tap if callback is provided
              onTap: onDateUpdate != null ? selectDate : null,
              borderRadius: BorderRadius.circular(4), // Rounded corners for tap effect
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // Apply visual highlight styling if needed
                decoration:
                    isEffectivelyHighlighted
                        ? BoxDecoration(
                          color: primaryColor.withAlpha(26), // Light background tint
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: primaryColor.withAlpha(77), width: 1), // Subtle border
                        )
                        : null, // No decoration if not highlighted
                child: Text(
                  // Format the date, display 'N/A' if null
                  entry.date != null ? DateFormat.yMMMd().format(entry.date!) : 'N/A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isEffectivelyHighlighted ? FontWeight.bold : FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the visual indicator row for "Today"
  Widget _buildTodayIndicator(
    BuildContext context,
    Color dotColor, // Color for the indicator dot (usually secondary)
    Color lineTopColor, // Color for the line segment above the dot
    Color lineBottomColor, { // Color for the line segment below the dot
    required bool isFirstIndicator, // Is this the very first element in the timeline?
    required bool isLastIndicator, // Is this the very last element in the timeline?
  }) {
    final theme = Theme.of(context);
    // Text style for the "Today" label
    final textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: dotColor);

    // --- Constants for layout ---
    const double dotSize = 10.0;
    const double dotBorderSize = 1.5;
    // Height for the indicator row, slightly shorter than item rows for visual rhythm
    const double verticalIndicatorHeight = 24.0;
    const double lineHorizontalPosition = 14.0; // Same as item line X
    const double dotHorizontalPosition = 10.0; // Same as item dot X
    // Calculate vertical center for the dot within the indicator's height
    const double dotVerticalPosition = (verticalIndicatorHeight - dotSize) / 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Vertically center content in the row
      children: [
        const Expanded(child: SizedBox.shrink()), // Left spacer to align with item labels
        // --- Center - Line and Dot ---
        SizedBox(
          width: 30, // Fixed width column
          height: verticalIndicatorHeight, // Use specific height for the indicator row
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Top Connecting Line Segment (drawn only if NOT the first element)
              if (!isFirstIndicator)
                Positioned(
                  top: 0, // Start from the top edge
                  // End at the vertical center of the dot
                  bottom: dotVerticalPosition + (dotSize / 2),
                  left: lineHorizontalPosition,
                  width: 2,
                  child: Container(color: lineTopColor), // Use color from item above
                ),
              // Bottom Connecting Line Segment (drawn only if NOT the last element)
              if (!isLastIndicator)
                Positioned(
                  // Start from the vertical center of the dot
                  top: dotVerticalPosition + (dotSize / 2),
                  bottom: 0, // End at the bottom edge
                  left: lineHorizontalPosition,
                  width: 2,
                  child: Container(color: lineBottomColor), // Use color for item below
                ),
              // Today Dot (always drawn)
              Positioned(
                left: dotHorizontalPosition,
                top: dotVerticalPosition, // Position dot vertically centered
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: dotColor, // Use the passed dot color (secondary)
                    shape: BoxShape.circle,
                    // White border for visual separation from the line
                    border: Border.all(color: Colors.white, width: dotBorderSize),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Right side - "Today" Text ---
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0), // Padding for the text
            child: Text('Today', style: textStyle, textAlign: TextAlign.left),
          ),
        ),
      ],
    );
  }
} // End of DateTimeline class
