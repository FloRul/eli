// lot_item_card.dart

import 'package:client/features/lots/models/lot_item.dart';
import 'package:client/features/lots/widgets/lot_item/comment_section.dart';
import 'package:client/features/lots/widgets/lot_item/header_section.dart';
import 'package:client/features/lots/widgets/lot_item/key_dates_section.dart';
import 'package:client/features/lots/widgets/lot_item/progress_section.dart';
import 'package:flutter/material.dart';

// Main Widget
class LotItemCard extends StatelessWidget {
  final LotItem item;
  const LotItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasComments = item.comments != null && item.comments!.isNotEmpty;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(item: item),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final showCommentsInline = isWide && hasComments;

                // Instantiate section widgets
                final keyDatesSection = KeyDatesSection(item: item);
                final progressSection = ProgressSection(item: item);
                final commentsSection = hasComments ? CommentsSection(comments: item.comments!) : null;

                // Arrange sections based on width
                if (isWide) {
                  return Row(
                    spacing: 24,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 2, child: keyDatesSection),
                      Expanded(flex: 3, child: progressSection),
                      if (showCommentsInline) ...[Expanded(flex: 2, child: commentsSection!)],
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      keyDatesSection,
                      const SizedBox(height: 16),
                      progressSection,
                      if (commentsSection != null) ...[const SizedBox(height: 16), commentsSection],
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
