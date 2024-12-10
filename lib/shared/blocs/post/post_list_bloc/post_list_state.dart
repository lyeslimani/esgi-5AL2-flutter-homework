part of 'post_list_bloc.dart';

enum PostListStatus {
  initial,
  loading,
  success,
  error,
}

@immutable
class PostListState {
  final PostListStatus status;
  final List<Post> postLists;
  final AppException? exception;

  const PostListState({
    this.status = PostListStatus.initial,
    this.postLists = const [],
    this.exception,
  });

  PostListState copyWith({
    PostListStatus? status,
    List<Post>? postLists,
    AppException? exception,
  }) {
    return PostListState(
      status: status ?? this.status,
      postLists: postLists ?? this.postLists,
      exception: exception ?? this.exception,
    );
  }
}
