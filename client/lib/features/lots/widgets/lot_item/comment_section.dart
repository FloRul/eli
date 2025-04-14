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

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print('Focus gained for ${comments.hashCode}');
      }
      if (!focusNode.hasFocus) {
        print('Focus lost for ${comments.hashCode}');
        FocusScope.of(context).unfocus();
      }
    });
    final commentsController = useTextEditingController(text: comments);
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        commentsController.text = comments;
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Comments', icon: Icons.comment),
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
            key: ValueKey(comments.hashCode),
            focusNode: focusNode,
            controller: commentsController,
            onSubmitted: (value) {
              onCommentsChanged(value);
            },
            onEditingComplete: () {
              onCommentsChanged(commentsController.text);
            },
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
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: focusNode.hasFocus ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filled(icon: Icon(Icons.check), onPressed: () => onCommentsChanged(commentsController.text)),
                const SizedBox(width: 8),
                IconButton(icon: Icon(Icons.clear), onPressed: () => commentsController.text = comments),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
