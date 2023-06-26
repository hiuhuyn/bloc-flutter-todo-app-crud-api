import 'dart:async';

import 'package:flutter_app_fontend/bloc/event/post_event.dart';
import 'package:flutter_app_fontend/bloc/state/post_state.dart';
import 'package:flutter_app_fontend/repo/network/networkApiService.dart';
import 'package:flutter_app_fontend/utils/app_url.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final NetworkApiService _networkApiService = NetworkApiService();
  PostBloc() : super(PostState()) {
    on<GetAllPostEvent>(getAllPostEventBloc);
    on<GetPostByIdEvent>(getPostByIdEventBloc);
    on<AddPostEvent>(addPostEventBloc);
    on<UpdatePostEvent>(updatePostEventBloc);
    on<DeletePostEvent>(deletePostEventBloc);
  }

  FutureOr<void> getAllPostEventBloc(
      GetAllPostEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());
    try {
      List<Post> posts =
          await _networkApiService.getAllPostApiResponse(AppUrl.selectAllPost);
      emit(state.copyWith(posts: posts));
    } catch (e) {
      print("Error getAllPostEvent bloc: $e");
      emit(PostErrorState(error: e.toString()));
    }
  }

  FutureOr<void> getPostByIdEventBloc(
      GetPostByIdEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());
    try {
      var post = await _networkApiService
          .getPostByIdApiResponse("${AppUrl.selectPostById}${event.id}");
      emit(PostSearchState(post: post));
    } catch (e) {
      emit(PostErrorState(error: e.toString()));
    }
  }

  FutureOr<void> addPostEventBloc(
      AddPostEvent event, Emitter<PostState> emit) async {
    try {
      List<Post> listPost = List.from(state.posts);
      emit(PostLoadingState());
      String idPost = await _networkApiService.createPostApiResponse(
          AppUrl.createPost, event.post.toJson());
      Post post = await _networkApiService
          .getPostByIdApiResponse(AppUrl.selectPostById + idPost);
      listPost.add(post);
      emit(PostState(posts: listPost));
    } catch (e) {
      emit(PostErrorState(error: e.toString()));
    }
  }

  FutureOr<void> updatePostEventBloc(
      UpdatePostEvent event, Emitter<PostState> emit) async {
    try {
      List<Post> listPost = List.from(state.posts);
      emit(PostLoadingState());
      await _networkApiService.updatePostApiResponse(
          AppUrl.updatePost, event.post.toJson());
      Post post = await _networkApiService
          .getPostByIdApiResponse("${AppUrl.selectPostById}${event.post.id}");
      int index = listPost.indexWhere((element) => post.id == element.id);
      if (index != -1) {
        listPost.replaceRange(index, index + 1, [post]);
        emit(PostState(posts: listPost));
      } else {
        throw Exception("Id is not a valid");
      }
    } catch (e) {
      emit(PostErrorState(error: e.toString()));
    }
  }

  FutureOr<void> deletePostEventBloc(
      DeletePostEvent event, Emitter<PostState> emit) async {
    try {
      List<Post> listPost = List.from(state.posts);
      emit(PostLoadingState());
      await _networkApiService
          .deleteByIdPostApiResponse("${AppUrl.deletePostById}${event.id}");
      int index = listPost.indexWhere((element) => event.id == element.id);
      if (index != -1) {
        listPost.removeAt(index);
        emit(PostState(posts: listPost));
      } else {
        throw Exception("Id is not a valid");
      }
    } catch (e) {
      emit(PostErrorState(error: e.toString()));
    }
  }
}
