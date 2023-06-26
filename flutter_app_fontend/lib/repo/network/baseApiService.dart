import '../../models/post.dart';

abstract class BaseApiService {
  Future<List<Post>> getAllPostApiResponse(String url);
  Future<Post> getPostByIdApiResponse(String url);
  Future<String> createPostApiResponse(String url, dynamic data);
  Future<dynamic> updatePostApiResponse(String url, dynamic data);
  Future<dynamic> deleteByIdPostApiResponse(String url);
}
