part of 'post_bloc.dart';

@immutable
sealed class PostEvent {
  const PostEvent();
}

class CreateNewPost extends PostEvent {
  final String title;
  final String description;

  const CreateNewPost({
    required this.title,
    required this.description,
  });
}

class UpdatePost extends PostEvent {
  final String id;
  final String title;
  final String description;

  const UpdatePost({
    required this.id,
    required this.title,
    required this.description,
  });
}
