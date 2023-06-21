import 'dart:async';

import 'package:flutter_app_fontend/bloc/event/post_event.dart';
import 'package:flutter_app_fontend/bloc/state/post_state.dart';
import 'package:flutter_app_fontend/repo/network/networkApiService.dart';
import 'package:flutter_app_fontend/utils/app_url.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final NetworkApiService _networkApiService = NetworkApiService();
  PostBloc() : super(InitPostState()) {
    on<GetAllPostEvent>(getAllPostEventBloc);
    on<GetPostByIdEvent>(getPostByIdEventBloc);
    on<AddPostEvent>(addPostEventBloc);
    on<UpdatePostEvent>(updatePostEventBloc);
    on<DeletePostEvent>(deletePostEventBloc);
  }

  FutureOr<void> getAllPostEventBloc(
      GetAllPostEvent event, Emitter<PostState> emit) async {
    emit(PostsFetchingLoadingState());
    try {
      List<Post> posts =
          await _networkApiService.getAllPostApiResponse(AppUrl.selectAllPost);
      print("Posts getAll : ${posts}");
      emit(PostFetchingSuccessfulState(posts: posts));
    } catch (e) {
      print("Error getAllPostEvent bloc: $e");
      emit(PostsFetchingErrorState());
    }
  }

  FutureOr<void> getPostByIdEventBloc(
      GetPostByIdEvent event, Emitter<PostState> emit) async {
    emit(PostsFetchingLoadingState());
    try {
      var post = await _networkApiService
          .getPostByIdApiResponse("${AppUrl.selectPostById}${event.id}");
      emit(PostSearchSuccessfullState(post: post));
    } catch (e) {
      print(e);
      emit(PostsFetchingErrorState());
    }
  }

  FutureOr<void> addPostEventBloc(
      AddPostEvent event, Emitter<PostState> emit) async {
    try {
      var post = event.post.toJson();
      await _networkApiService.createPostApiResponse(AppUrl.createPost, post);
    } catch (e) {
      print(e);
      emit(PostsFetchingErrorState());
    }
  }

  FutureOr<void> updatePostEventBloc(
      UpdatePostEvent event, Emitter<PostState> emit) async {
    try {
      var post = event.post.toJson();
      await _networkApiService.updatePostApiResponse(AppUrl.updatePost, post);
    } catch (e) {
      print(e);
      emit(PostsFetchingErrorState());
    }
  }

  FutureOr<void> deletePostEventBloc(
      DeletePostEvent event, Emitter<PostState> emit) async {
    emit(PostsFetchingLoadingState());
    try {
      await _networkApiService
          .deleteByIdPostApiResponse("${AppUrl.deletePostById}${event.id}");
      List<Post> posts =
          await _networkApiService.getAllPostApiResponse(AppUrl.selectAllPost);
      emit(PostFetchingSuccessfulState(posts: posts));
    } catch (e) {
      print(e);
      emit(PostsFetchingErrorState());
    }
  }
}
