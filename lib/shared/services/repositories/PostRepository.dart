import 'package:lyes_slimani_dm/shared/services/remote_posts/api_post_source/remote_post_data_source.dart';

import '../../models/post.dart';

class PostRepository {
  final RemotePostDataSource remotePostDataSource;

  PostRepository({required this.remotePostDataSource});

  Future<List<Post>> getAllPosts() {
    return remotePostDataSource.getAllPosts();
  }

  Future<Post> createPost(
      {required String title, required String description}) {
    return remotePostDataSource.createPost(
        title: title, description: description);
  }

  Future<Post> updatePost(
      {required String id,
      required String title,
      required String description}) {
    return remotePostDataSource.updateOnePost(
        id: id, title: title, description: description);
  }
}
