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
