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

class SyncUpdatedPost extends PostListEvent {
  final Post post;

  const SyncUpdatedPost({required this.post});
}
