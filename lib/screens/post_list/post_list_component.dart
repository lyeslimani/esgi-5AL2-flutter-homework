import 'package:flutter/material.dart';
import 'package:lyes_slimani_dm/screens/post_list/post_list_item.dart';

import '../../shared/models/post.dart';

class PostListComponent extends StatefulWidget {
  final List<Post> postList;
  final Future<void> Function()? refreshCallback;

  const PostListComponent({
    super.key,
    required this.postList,
    this.refreshCallback,
  });

  @override
  State<PostListComponent> createState() => _PostListComponentState();
}

class _PostListComponentState extends State<PostListComponent> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.separated(
      itemBuilder: (context, index) {
        final post = widget.postList[index];
        return ListTile(
          minVerticalPadding: 0,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          onTap: () => Navigator.pushNamed(
            context,
            'post',
            arguments: post,
          ),
          title: PostListItem(
            post: post,
            longPressCallback: () => goToPostEdition(post),
          ),
        );
      },
      itemCount: widget.postList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );

    final content = widget.refreshCallback != null
        ? RefreshIndicator(
            displacement: Scaffold.of(context).appBarMaxHeight ?? 40,
            onRefresh: widget.refreshCallback!,
            child: listView,
          )
        : listView;

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: content,
      ),
    );
  }

  void goToPostEdition(Post postToUpdate) {
    Navigator.pushNamed(context, 'post?view=edit', arguments: postToUpdate);
  }
}
