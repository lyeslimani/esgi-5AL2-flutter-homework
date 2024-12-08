import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: Colors.orange,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              getAllPosts();
            },
            child: Container(
              color: Colors.red,
              child: switch (state.status) {
                PostListStatus.initial ||
                PostListStatus.loading =>
                  _buildLoading(),
                PostListStatus.error => _buildError(state.exception),
                PostListStatus.success => _buildSuccess(state.postLists),
              },
            ),
          ),
        );
      },
    );
  }

  void onPressed() {
    createNewPost();
  }

  void getAllPosts() {
    final postListBloc = context.read<PostListBloc>();
    postListBloc.add(GetAllPost());
  }

  updatePost(String id, String newTitle, String newDescrption) {
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

  _buildSuccess(List<Post> postList) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final post = postList[index];
        return ListTile(
            onLongPress: () => updatePost(post.id, 'Updated ${post.title}',
                'Updated ${post.description}'),
            title: Container(
              color: Colors.lightGreen,
              child: Column(
                children: [
                  Container(
                    color: Colors.lightBlue,
                    child: Row(
                      children: [
                        Text(post.title),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(post.description),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
      itemCount: postList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }

  _buildLoading() {
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
