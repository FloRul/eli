// Comments Section
import 'package:client/features/lots/widgets/lot_item/section_title.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommentsSection extends HookConsumerWidget {
  const CommentsSection({super.key, required this.comments, required this.onCommentsChanged});

  final String comments;
  final Function(String) onCommentsChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final focusNode = useFocusNode();
    final commentsController = useTextEditingController(text: comments);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Comments', icon: Icons.comment_outlined),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
          ),
          child: TextField(
            focusNode: focusNode,
            controller: commentsController,
            onSubmitted: (value) => onCommentsChanged(value),
            onEditingComplete: () => onCommentsChanged(commentsController.text),
            style: theme.textTheme.bodyMedium,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your comments here...',
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            maxLines: 5, // Allows multiline input
          ),
        ),
        Visibility.maintain(
          visible: focusNode.hasFocus,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => onCommentsChanged(commentsController.text), child: const Text('Save')),
              const SizedBox(width: 8),
              TextButton(onPressed: () => commentsController.text = comments, child: const Text('Cancel')),
            ],
          ),
        ),
      ],
    );
  }
}
