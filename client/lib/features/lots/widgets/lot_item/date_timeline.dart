import 'package:flutter/material.dart';
import 'package:client/features/lots/models/timeline_entry.dart'; // Assuming path is correct
import 'package:intl/intl.dart';

// Callback type remains the same
typedef DateUpdateCallback = void Function(TimelineEntry entry, DateTime newDate);

class DateTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final DateUpdateCallback? onDateUpdate;
  final bool showTodayIndicator;

  static const double _dotSize = 10.0;
  static const double _dotBorderSize = 1.5;
  static const double _verticalItemHeight = 36.0;
  static const double _lineHorizontalPosition = 14.0;
  static const double _dotHorizontalPosition = 10.0;
  static const double _dotVerticalPosition = (_verticalItemHeight - _dotSize) / 2;

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
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return a.date!.compareTo(b.date!);
    });

    // --- 2. Find Today's Position ---
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int todayIndicatorIndex = -1; // Default: don't show or not applicable yet

    if (showTodayIndicator) {
      todayIndicatorIndex = -2; // Assume today is before all entries initially
      for (int i = 0; i < sortedEntries.length; i++) {
        final entryDate = sortedEntries[i].date;
        if (entryDate == null) {
          // If an entry has no date, treat it as future for today indicator placement
          break; // Stop searching, today is before this null-dated entry
        }
        // If entry date is on or before today, today is at least after this entry
        if (!entryDate.isAfter(today)) {
          todayIndicatorIndex = i;
        } else {
          // Found the first entry *after* today, so break
          break;
        }
      }
      // If after checking all entries, todayIndicatorIndex is still -2,
      // it means all entries are in the future (or list is empty).
      // If all entries are *exactly* today or in the past,
      // todayIndicatorIndex will be the index of the last entry.
      // A final check for empty list case:
      if (sortedEntries.isEmpty) {
        todayIndicatorIndex = -2; // Needs the 'before all' handling
      }
    }

    // --- Build Widgets ---
    List<Widget> children = [];

    // A. Add indicator *before* all items if needed
    if (showTodayIndicator && todayIndicatorIndex == -2) {
      final bool isAlsoLast = sortedEntries.isEmpty;
      final Color nextItemLineColor =
          sortedEntries.isNotEmpty
              ? _getLineColor(sortedEntries[0], today, primaryColor, colorScheme)
              : Colors.grey.shade300; // Default if empty
      // prevItemLineColor doesn't matter visually when isFirstIndicator is true
      final Color prevItemLineColor = todayDotColor;

      children.add(
        _buildTodayIndicator(
          context,
          todayDotColor,
          prevItemLineColor,
          nextItemLineColor,
          isFirstIndicator: true,
          isLastIndicator: isAlsoLast,
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
          today: today,
          // *** PASS todayIndicatorIndex ***
          todayIndicatorIndex: todayIndicatorIndex,
        ),
      );

      // Add indicator *after* the current item if needed
      // It should appear *after* item 'i' if todayIndicatorIndex is 'i'
      // and todayIndicatorIndex wasn't -2 (which was handled before the loop)
      if (showTodayIndicator && i == todayIndicatorIndex && todayIndicatorIndex != -2) {
        final bool isAlsoLast = isLastItem; // Today indicator is last if the item it follows is last
        final Color prevItemLineColor = _getLineColor(entry, today, primaryColor, colorScheme);
        final Color nextItemLineColor;
        if (isAlsoLast) {
          // If this is the last indicator, the bottom line color doesn't visually matter
          nextItemLineColor = todayDotColor;
        } else {
          nextItemLineColor = _getLineColor(sortedEntries[i + 1], today, primaryColor, colorScheme);
        }

        children.add(
          _buildTodayIndicator(
            context,
            todayDotColor,
            prevItemLineColor,
            nextItemLineColor,
            isFirstIndicator: false, // It's never the first if it's in this loop
            isLastIndicator: isAlsoLast,
          ),
        );
      }
    }

    // C. Handle case where Today is *after* all items (if needed and not already handled)
    // This might be needed if showTodayIndicator is true and todayIndicatorIndex ended up
    // being the index of the *last* item, but wasn't handled *after* the last item in the loop.
    // Let's refine the logic slightly. The loop handles placing *between* or *after* an item.
    // The block 'A' handles placement *before* all items.
    // So, if todayIndicatorIndex == sortedEntries.length - 1, the indicator was added *after*
    // the last item inside the loop, correctly marking it as the last indicator.
    // Thus, an extra block C might not be needed if the logic in A and B is robust. Let's stick with A & B.

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  // Helper to determine line color (remains the same)
  Color _getLineColor(TimelineEntry entry, DateTime today, Color primaryColor, ColorScheme colorScheme) {
    final entryDate = entry.date;
    // Treat null date as future for coloring
    final bool isPast = entryDate != null && entryDate.isBefore(today);
    final bool isToday =
        entryDate != null &&
        entryDate.year == today.year &&
        entryDate.month == today.month &&
        entryDate.day == today.day;
    // Highlight takes precedence
    final bool isHighlighted = entry.isHighlighted;

    if (isHighlighted) {
      // If highlighted, use primary color, slightly faded if past, solid otherwise (or if today)
      return isPast ? primaryColor.withAlpha(128) : primaryColor;
    } else if (isToday) {
      // If today (and not highlighted), use primary color
      return primaryColor;
    } else if (isPast) {
      // If past (and not highlighted/today), use faded primary
      return primaryColor.withAlpha(128);
    } else {
      // Future or null date (and not highlighted)
      return Colors.grey.shade400; // Use a slightly darker grey for future lines
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
    required DateTime today,
    // *** RECEIVE todayIndicatorIndex ***
    required int todayIndicatorIndex,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entryDate = entry.date;

    // Determine state
    // Treat null date as future for state determination
    final bool isPast = entryDate != null && entryDate.isBefore(today);
    final bool isToday =
        entryDate != null &&
        entryDate.year == today.year &&
        entryDate.month == today.month &&
        entryDate.day == today.day;
    // Use highlighted status directly
    final bool isEffectivelyHighlighted = entry.isHighlighted || isToday;

    // Determine Colors
    final Color dotColor;
    final Color textColor;
    // Use the getLineColor helper for consistency
    final Color lineColor = _getLineColor(entry, today, primaryColor, colorScheme);

    if (isEffectivelyHighlighted) {
      dotColor = primaryColor;
      textColor = primaryColor;
    } else if (isPast) {
      // Keep past text slightly less prominent than future/highlighted
      dotColor = primaryColor.withAlpha(128);
      textColor = colorScheme.onSurface.withAlpha(230);
    } else {
      // Future or null date
      dotColor = Colors.grey.shade400; // Match future line color
      textColor = colorScheme.onSurface.withAlpha(153); // Greyed out text
    }

    // Date Picker Logic (remains the same)
    Future<void> selectDate() async {
      if (onDateUpdate == null) return;
      final now = DateTime.now();
      DateTime initial = entry.date ?? now;
      // Make selectable range reasonable, e.g., 10 years back/forward
      final DateTime firstSelectable = DateTime(now.year - 10);
      final DateTime lastSelectable = DateTime(now.year + 10);
      // Ensure initial date is within the valid range
      if (initial.isBefore(firstSelectable)) initial = firstSelectable;
      if (initial.isAfter(lastSelectable)) initial = lastSelectable;

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: firstSelectable,
        lastDate: lastSelectable,
      );
      if (picked != null) {
        onDateUpdate(entry, picked);
      }
    }

    // --- *** THE FIX IS HERE *** ---
    // Determine the top padding for the line segment
    double lineTopPadding = 0;
    // Default case: line starts from the middle of the dot if it's the first item
    if (isFirst) {
      // If it's the first item AND the Today indicator was drawn just before it,
      // the line needs to start from the top to connect smoothly.
      if (showTodayIndicator && todayIndicatorIndex == -2) {
        lineTopPadding = 0; // Start line from the very top
      } else {
        // Otherwise (it's the first item but no Today indicator before it),
        // start the line from the dot's center.
        lineTopPadding = _dotVerticalPosition + (_dotSize / 2);
      }
    } else {
      // If it's not the first item, the line always starts from the top.
      lineTopPadding = 0;
    }

    // Determine the bottom padding for the line segment
    final double lineBottomPadding =
        isLast
            ? _dotVerticalPosition +
                (_dotSize / 2) // Line ends at dot center if last
            : 0; // Line goes to the bottom edge otherwise

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Left side - Label ---
        Expanded(
          child: Padding(
            // Add consistent vertical padding to align text better with the dot center
            padding: const EdgeInsets.only(
              top: (_verticalItemHeight - 18) / 2,
              right: 4.0,
            ), // Adjust 18 based on font size/line height if needed
            child: Text(
              entry.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isEffectivelyHighlighted ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.right,
              maxLines: 2, // Allow wrapping
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // --- Center - Line and Dot ---
        SizedBox(
          width: 30,
          height: _verticalItemHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical Line Segment (Using calculated paddings)
              Positioned(
                top: lineTopPadding, // Apply calculated top padding
                bottom: lineBottomPadding, // Apply calculated bottom padding
                left: _lineHorizontalPosition,
                width: 2,
                child: Container(color: lineColor),
              ),
              // Dot
              Positioned(
                left: _dotHorizontalPosition,
                top: _dotVerticalPosition,
                child: Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    // Consider making border conditional or themed
                    border: Border.all(color: theme.canvasColor, width: _dotBorderSize),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Right side - Date ---
        Expanded(
          child: Padding(
            // Add consistent vertical padding like the label
            padding: const EdgeInsets.only(top: (_verticalItemHeight - 18) / 2, left: 4.0), // Adjust 18 similarly
            child: InkWell(
              onTap: onDateUpdate != null ? selectDate : null,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    isEffectivelyHighlighted &&
                            entry.date !=
                                null // Only decorate if there's a date
                        ? BoxDecoration(
                          color: primaryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: primaryColor.withAlpha(77), width: 1),
                        )
                        : null,
                child: Text(
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

  // _buildTodayIndicator remains largely the same, ensure colors passed are correct
  Widget _buildTodayIndicator(
    BuildContext context,
    Color dotColor,
    Color lineTopColor,
    Color lineBottomColor, {
    required bool isFirstIndicator,
    required bool isLastIndicator,
  }) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: dotColor);

    // Determine the top padding for the top line segment
    // Top line segment should always start from the top edge if it exists
    final double topSegmentTopPadding = 0;
    // Top line segment ends just above the center of the dot
    final double topSegmentBottomPadding = _dotVerticalPosition + (_dotSize / 2);

    // Determine the top padding for the bottom line segment
    // Bottom line segment starts just below the center of the dot
    final double bottomSegmentTopPadding = _dotVerticalPosition + (_dotSize / 2);
    // Bottom line segment should always end at the bottom edge if it exists
    final double bottomSegmentBottomPadding = 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically in the row
      children: [
        const Expanded(child: SizedBox.shrink()), // Left spacer remains
        // --- Center - Line and Dot ---
        SizedBox(
          width: 30,
          height: _verticalItemHeight, // Use shared height
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Top Connecting Line Segment (Draws if NOT the first indicator)
              if (!isFirstIndicator)
                Positioned(
                  top: topSegmentTopPadding,
                  bottom: topSegmentBottomPadding,
                  left: _lineHorizontalPosition, // Use shared constant
                  width: 2,
                  child: Container(color: lineTopColor),
                ),
              // Bottom Connecting Line Segment (Draws if NOT the last indicator)
              if (!isLastIndicator)
                Positioned(
                  top: bottomSegmentTopPadding,
                  bottom: bottomSegmentBottomPadding,
                  left: _lineHorizontalPosition, // Use shared constant
                  width: 2,
                  child: Container(color: lineBottomColor),
                ),
              // Today Dot
              Positioned(
                left: _dotHorizontalPosition, // Use shared constant
                top: _dotVerticalPosition, // Use shared constant
                child: Container(
                  width: _dotSize, // Use shared constant
                  height: _dotSize, // Use shared constant
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    // Use theme canvas color for border for better theme adaptability
                    border: Border.all(color: theme.canvasColor, width: _dotBorderSize),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Right side - "Today" Text ---
        Expanded(
          child: Padding(
            // Adjust padding to vertically center the text with the dot
            padding: const EdgeInsets.only(
              left: 4.0,
              top: (_verticalItemHeight - 16) / 2,
            ), // Adjust 16 based on text style
            child: Text('Today', style: textStyle, textAlign: TextAlign.left),
          ),
        ),
      ],
    );
  }
}
