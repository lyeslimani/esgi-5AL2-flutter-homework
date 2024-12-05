import 'package:lyes_slimani_dm/shared/exceptions/app_exception.dart';
import 'package:lyes_slimani_dm/shared/services/remote_posts/api_post_source/remote_post_data_source.dart';

import '../../../models/post.dart';

class FakePostDataSource extends RemotePostDataSource {
  final List<Post> _fakePosts = [
    const Post(id: '1', title: 'Post 1', description: 'Description of'),
    const Post(id: '2', title: 'Post 2', description: 'Description of'),
    const Post(id: '3', title: 'Post 3', description: 'Description of'),
  ];

  @override
  Future<List<Post>> getAllPosts() async {
    List<Post> posts = List.from(_fakePosts);
    await Future.delayed(const Duration(seconds: 3));
    return posts;
  }

  @override
  Future<Post> createPost({required title, required description}) async {
    Post newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description);
    _fakePosts.add(newPost);
    return newPost;
  }

  @override
  Future<Post> updateOnePost({
    required id,
    required title,
    required description,
  }) async {
    int postToUpdateIndex = _fakePosts.indexWhere((post) => post.id == id);
    if (postToUpdateIndex == -1) {
      throw PostDoesNotExistException();
    }
    await Future.delayed(const Duration(seconds: 2));
    Post updatedPost = Post(id: id, title: title, description: description);
    _fakePosts[postToUpdateIndex] = updatedPost;

    return updatedPost;
  }
}
