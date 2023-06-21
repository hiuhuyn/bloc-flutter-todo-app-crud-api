import 'package:equatable/equatable.dart';

import '../../models/post.dart';

abstract class PostState extends Equatable {}

class InitPostState extends PostState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PostsFetchingLoadingState extends PostState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PostsFetchingErrorState extends PostState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PostFetchingSuccessfulState extends PostState {
  List<Post> posts = [];
  PostFetchingSuccessfulState({required this.posts});

  @override
  // TODO: implement props
  List<Object?> get props => [posts];
}

class PostSearchSuccessfullState extends PostState {
  Post post;
  PostSearchSuccessfullState({required this.post});
  @override
  // TODO: implement props
  List<Object?> get props => [post];
}
