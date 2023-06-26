// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../models/post.dart';

class PostState extends Equatable {
  List<Post> posts;
  PostState({this.posts = const <Post>[]});

  @override
  // TODO: implement props
  List<Object?> get props => [posts];

  PostState copyWith({
    List<Post>? posts,
  }) {
    return PostState(
      posts: posts ?? this.posts,
    );
  }
}

class PostLoadingState extends PostState {}

class PostErrorState extends PostState {
  String error = "";
  PostErrorState({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class PostSearchState extends PostState {
  Post post;
  PostSearchState({required this.post});
  @override
  // TODO: implement props
  List<Object?> get props => [post];
}
