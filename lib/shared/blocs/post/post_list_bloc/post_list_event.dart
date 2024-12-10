part of 'post_list_bloc.dart';

@immutable
sealed class PostListEvent {
  const PostListEvent();
}

class GetAllPost extends PostListEvent {}

class AddNewlyCreatedPost extends PostListEvent {
  final Post post;

  const AddNewlyCreatedPost({required this.post});
}

class UpdatePost extends PostListEvent {
  final String id;
  final String title;
  final String description;

  const UpdatePost({
    required this.id,
    required this.title,
    required this.description,
  });
}
