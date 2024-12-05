import '../../../models/post.dart';

abstract class RemotePostDataSource {
  Future<List<Post>> getAllPosts();

  Future<Post> createPost({
    required final title,
    required final description,
  });

  Future<Post> updateOnePost({
    required final id,
    required final title,
    required final description,
  });
}
