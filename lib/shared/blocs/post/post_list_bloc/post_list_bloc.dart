import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lyes_slimani_dm/shared/services/repositories/PostRepository.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/post.dart';
import '../post_bloc/post_bloc.dart';
import '../post_bloc/post_state.dart';

part 'post_list_event.dart';
part 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final PostRepository postRepository;
  late StreamSubscription<PostState> _postBlocSubscription;

  PostListBloc({
    required this.postRepository,
    required PostBloc postBloc,
  }) : super(const PostListState()) {
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

    on<AddNewlyCreatedPost>((event, emit) {
      emit(state.copyWith(
        status: PostListStatus.success,
        postLists: [...state.postLists, event.post],
      ));
    });

    on<SyncUpdatedPost>((event, emit) {
      try {
        int indexOfPostToUpdate =
            state.postLists.indexWhere((post) => post.id == event.post.id);
        if (indexOfPostToUpdate == -1) {
          throw PostDoesNotExistException();
        }
        List<Post> updatedPostList = List.from(state.postLists);
        updatedPostList[indexOfPostToUpdate] = event.post;
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

    _postBlocSubscription = postBloc.stream.listen((postState) {
      switch (postState.status) {
        case PostStatus.successCreatingPost:
          if (postState.lastUpdatedPost != null) {
            add(AddNewlyCreatedPost(post: postState.lastUpdatedPost!));
          }
          break;
        case PostStatus.successUpdatingPost:
          if (postState.lastUpdatedPost != null) {
            add(SyncUpdatedPost(post: postState.lastUpdatedPost!));
          }
        default:
          return;
      }
    });

    @override
    Future<void> close() {
      _postBlocSubscription.cancel();
      return super.close();
    }
  }
}
