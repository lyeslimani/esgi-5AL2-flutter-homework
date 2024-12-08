import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyes_slimani_dm/screens/post_list/post_list_item.dart';
import 'package:lyes_slimani_dm/shared/blocs/post_bloc/post_list_bloc.dart';
import 'package:lyes_slimani_dm/shared/exceptions/app_exception.dart';
import 'package:lyes_slimani_dm/shared/models/post.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.home,
              size: 30,
            ),
            Text(
              'Home Timeline',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        flexibleSpace: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 22),
          child: ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.transparent,
                  ))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<PostListBloc, PostListState>(
        builder: (context, state) {
          return switch (state.status) {
            PostListStatus.initial || PostListStatus.loading => _buildLoading(),
            PostListStatus.error => _buildError(state.exception),
            PostListStatus.success => _buildSuccess(state.postLists, context),
          };
        },
      ),
    );
  }

  void onPressed() {
    createNewPost();
  }

  void getAllPosts() {
    final postListBloc = context.read<PostListBloc>();
    postListBloc.add(GetAllPost());
  }

  void updatePost(String id, String newTitle, String newDescrption) {
    final postListBloc = context.read<PostListBloc>();
    postListBloc
        .add(UpdatePost(id: id, title: newTitle, description: newDescrption));
  }

  void createNewPost() {
    final postListBloc = context.read<PostListBloc>();
    postListBloc.add(const CreateNewPost(
      title: 'Post new Post',
      description: 'Description of new post',
    ));
  }

  Widget _buildSuccess(List<Post> postList, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: RefreshIndicator(
        displacement: Scaffold.of(context).appBarMaxHeight ?? 40,
        onRefresh: () async {
          getAllPosts();
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            final post = postList[index];
            return ListTile(
              minVerticalPadding: 0,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              onLongPress: () => updatePost(post.id, 'Updated ${post.title}',
                  'Updated ${post.description}'),
              title: PostListItem(post: post),
            );
          },
          itemCount: postList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(AppException? exception) {
    return Center(
      child: Text('Error: $exception'),
    );
  }
}
