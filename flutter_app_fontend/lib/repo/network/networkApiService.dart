import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_fontend/models/post.dart';

import '../app_excaptions.dart';
import 'baseApiService.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiService {
  @override
  Future createPostApiResponse(String url, data) async {
    try {
      var request = http.MultipartRequest("post", Uri.parse(url));
      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        data["image"],
      );
      request.files.add(multipartFile);
      request.fields["title"] = data["title"];
      request.send();
    } on SocketException {
      print("No internet Connection");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future deleteByIdPostApiResponse(String url) async {
    try {
      final resonse = await http.delete(Uri.parse(url));
      return returnResponse(resonse);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<Post>> getAllPostApiResponse(String url) async {
    try {
      final resonse =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      List<dynamic> result = returnResponse(resonse);
      List<Post> posts = result.map((e) => Post.fromJson(e)).toList();
      return posts;
    } catch (e) {
      print("Error getAllPostApiResponse: $e");
      return [];
    }
  }

  @override
  Future<Post> getPostByIdApiResponse(String url) async {
    try {
      final resonse =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      var result = returnResponse(resonse);
      print("Result getPostByIdApiResponse: $result");
      return Post.fromJson(result);
    } catch (e) {
      print("getPostByIdApiResponse: $e");
      throw FetchDataException("$e");
    }
  }

  @override
  Future updatePostApiResponse(String url, data) async {
    try {
      final resonse = await http
          .put(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      return returnResponse(resonse);
    } catch (e) {
      print(e);
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responsejson = jsonDecode(response.body);
        return responsejson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            "Error accured while comminicating with server with status code${response.statusCode}");
    }
  }
}
