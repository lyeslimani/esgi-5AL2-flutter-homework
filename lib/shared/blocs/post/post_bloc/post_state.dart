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
  final Post? lastUpdatedPost;

  const PostState({
    this.status = PostStatus.initial,
    this.exception,
    this.lastUpdatedPost,
  });

  PostState copyWith({
    PostStatus? status,
    AppException? exception,
    Post? createdPost,
  }) {
    return PostState(
      status: status ?? this.status,
      exception: exception,
      lastUpdatedPost: createdPost ?? this.lastUpdatedPost,
    );
  }
}
