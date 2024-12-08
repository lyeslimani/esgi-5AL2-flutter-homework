import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lyes_slimani_dm/shared/services/repositories/PostRepository.dart';

import '../../exceptions/app_exception.dart';
import '../../models/post.dart';

part 'post_list_event.dart';
part 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final PostRepository postRepository;

  PostListBloc({required this.postRepository}) : super(const PostListState()) {
    on<GetAllPost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostListStatus.loading));
        final posts = await postRepository.getAllPosts();
        emit(state.copyWith(
          status: PostListStatus.success,
          postLists: posts,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostListStatus.error,
          exception: appException,
        ));
      }
    });

    on<CreateNewPost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostListStatus.loading));
        Post createdPost = await postRepository.createPost(
            title: event.title, description: event.description);
        emit(state.copyWith(
          status: PostListStatus.success,
          postLists: [...state.postLists, createdPost],
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostListStatus.error,
          exception: appException,
        ));
      }
    });
    on<UpdatePost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostListStatus.loading));
        Post updatedPost = await postRepository.updatePost(
          id: event.id,
          title: event.title,
          description: event.description,
        );
        int indexOfPostToUpdate =
            state.postLists.indexWhere((post) => post.id == event.id);
        if (indexOfPostToUpdate == -1) {
          throw PostDoesNotExistException();
        }
        List<Post> updatedPostList = List.from(state.postLists);
        updatedPostList[indexOfPostToUpdate] = updatedPost;
        emit(state.copyWith(
          status: PostListStatus.success,
          postLists: updatedPostList,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostListStatus.error,
          exception: appException,
        ));
      }
    });
  }
}
