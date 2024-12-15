import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/models/post.dart';

class PostListItem extends StatefulWidget {
  final Post post;
  final VoidCallback? longPressCallback;

  const PostListItem({super.key, required this.post, this.longPressCallback});

  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  bool _isExpanded = false;
  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    const TextStyle descriptionStyle = TextStyle(
      fontSize: 16,
    );

    final fullText = Text(
      widget.post.description,
      style: descriptionStyle,
    );
    const horizontalPadding = 24;
    final textSpan =
        TextSpan(text: widget.post.description, style: descriptionStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      maxWidth: MediaQuery.of(context).size.width - horizontalPadding,
    );

    final isOverflowing = textPainter.didExceedMaxLines;

    return GestureDetector(
      onLongPress: widget.longPressCallback,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 2, horizontal: horizontalPadding / 2),
              color: Colors.lightBlueAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      widget.post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: horizontalPadding / 2),
              child: GestureDetector(
                onLongPress: switchExpand,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isExpanded || !isOverflowing)
                      fullText
                    else
                      Text(
                        widget.post.description,
                        style: descriptionStyle,
                        maxLines: _maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (isOverflowing)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: switchExpand,
                          child: Text(
                            _isExpanded ? 'Show less' : 'Show more',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void switchExpand() {
    setState(() {
      HapticFeedback.lightImpact();
      _isExpanded = !_isExpanded;
    });
  }
}
