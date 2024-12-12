import 'package:flutter/widgets.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/post.dart';

enum PostStatus {
  initial,
  creatingPost,
  errorCreatingPost,
  successCreatingPost,
  updatingPost,
  errorUpdatingPost,
  successUpdatingPost,
}

@immutable
class PostState {
  final PostStatus status;
  final AppException? exception;
  final Post? createdPost;

  const PostState({
    this.status = PostStatus.initial,
    this.exception,
    this.createdPost,
  });

  PostState copyWith({
    PostStatus? status,
    AppException? exception,
    Post? createdPost,
  }) {
    return PostState(
      status: status ?? this.status,
      exception: exception,
      createdPost: createdPost ?? this.createdPost,
    );
  }
}
