import 'dart:math';
import 'package:flutter/material.dart';

OverlayEntry createOverlayEntry({
  required BuildContext context,
  required GlobalKey fieldKey,
  required LayerLink layerLink,
  required double maxHeight,
  required double minWidth,
  required double verticalMargin,
  required Widget Function() editorContentBuilder,
  required VoidCallback onTapOutside, // Callback for taps outside
}) {
  final renderBox = fieldKey.currentContext!.findRenderObject() as RenderBox;
  final targetSize = renderBox.size;
  final targetGlobalPosition = renderBox.localToGlobal(Offset.zero);
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  final spaceBelow = screenHeight - targetGlobalPosition.dy - targetSize.height - verticalMargin;
  final spaceAbove = targetGlobalPosition.dy - verticalMargin;

  bool renderAbove = spaceBelow < maxHeight && spaceAbove > spaceBelow;

  final Alignment targetAnchor = renderAbove ? Alignment.topLeft : Alignment.bottomLeft;
  final Alignment followerAnchor = renderAbove ? Alignment.bottomLeft : Alignment.topLeft;
  final Offset offset = renderAbove ? Offset(0, -verticalMargin) : Offset(0, targetSize.height + verticalMargin);

  final double calculatedWidth = max(minWidth, targetSize.width);
  final double editorWidth = min(calculatedWidth, screenWidth - 20);

  double horizontalOffset = 0;
  if (targetGlobalPosition.dx < 10) {
    horizontalOffset = 10 - targetGlobalPosition.dx;
  } else if (targetGlobalPosition.dx + editorWidth > screenWidth - 10) {
    horizontalOffset = (screenWidth - 10) - (targetGlobalPosition.dx + editorWidth);
  }

  final adjustedOffset = offset.translate(horizontalOffset, 0);

  return OverlayEntry(
    builder:
        (context) => Positioned(
          width: editorWidth,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: adjustedOffset,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            child: TapRegion(
              // Detect taps outside the Material boundary
              onTapOutside: (event) => onTapOutside(),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: SingleChildScrollView(
                    child: editorContentBuilder(), // Build the actual editor content
                  ),
                ),
              ),
            ),
          ),
        ),
  );
}
