import '../../models/post.dart';

abstract class PostEvent {}

class GetAllPostEvent extends PostEvent {}

class GetPostByIdEvent extends PostEvent {
  int id;
  GetPostByIdEvent({required this.id});
}

class AddPostEvent extends PostEvent {
  Post post;
  AddPostEvent({required this.post});
}

class UpdatePostEvent extends PostEvent {
  Post post;
  UpdatePostEvent({required this.post});
}

class DeletePostEvent extends PostEvent {
  int id;
  DeletePostEvent({required this.id});
}
