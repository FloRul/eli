// Comments Section
import 'package:client/features/lots/widgets/lot_item/section_title.dart';
import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final String comments;
  const CommentsSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Comments', icon: Icons.comment_outlined),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
          ),
          child: Text(comments, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
