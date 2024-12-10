import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lyes_slimani_dm/shared/blocs/post/post_bloc/post_state.dart';

import '../../../exceptions/app_exception.dart';
import '../../../services/repositories/PostRepository.dart';

part 'post_event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(const PostState()) {
    on<CreateNewPost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostStatus.creatingPost));
        final createdPost = await postRepository.createPost(
            title: event.title, description: event.description);
        emit(state.copyWith(
          status: PostStatus.successCreatingPost,
          createdPost: createdPost,
        ));
        emit(state.copyWith(
          status: PostStatus.initial,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostStatus.errorCreatingPost,
          exception: appException,
        ));
      }
    });
  }
}
