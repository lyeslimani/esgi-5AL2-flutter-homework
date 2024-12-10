import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyes_slimani_dm/screens/post/create_post.dart';
import 'package:lyes_slimani_dm/screens/post_list/post_list_component.dart';
import 'package:lyes_slimani_dm/shared/exceptions/app_exception.dart';

import '../../shared/blocs/post/post_bloc/post_bloc.dart';
import '../../shared/blocs/post/post_bloc/post_state.dart';
import '../../shared/blocs/post/post_list_bloc/post_list_bloc.dart';

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
      body: BlocListener<PostBloc, PostState>(
        listener: _onPostBlocListener,
        child: BlocBuilder<PostListBloc, PostListState>(
          builder: (context, state) {
            return switch (state.status) {
              PostListStatus.initial ||
              PostListStatus.loading =>
                _buildLoading(),
              PostListStatus.error => _buildError(state.exception),
              PostListStatus.success => PostListComponent(
                  postList: state.postLists,
                  refreshCallback: getAllPosts,
                ),
            };
          },
        ),
      ),
    );
  }

  void onPressed() {
    showCreationDialog();
  }

  Future<void> getAllPosts() async {
    final postListBloc = context.read<PostListBloc>();
    postListBloc.add(GetAllPost());
  }

  void updatePost(String id, String newTitle, String newDescrption) {
    final postListBloc = context.read<PostListBloc>();
    postListBloc
        .add(UpdatePost(id: id, title: newTitle, description: newDescrption));
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

  showCreationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12),
        child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.7,
            minChildSize: 0.6,
            snap: true,
            expand: false,
            snapSizes: const [
              0.7,
            ],
            builder: (_, scrollController) => Container(
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(28),
                      topLeft: Radius.circular(28),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const CreatePostForm()
                    ],
                  ),
                )),
      ),
    );
  }

  void _onPostBlocListener(BuildContext context, PostState state) {
    switch (state.status) {
      case PostStatus.successCreatingPost:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Text('Post ajouté avec succès'),
          ),
        );
      default:
        break;
    }
  }
}
