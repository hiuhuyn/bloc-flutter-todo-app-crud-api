import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_app_fontend/models/post.dart';
import 'package:flutter_app_fontend/utils/app_url.dart';

import '../app_excaptions.dart';
import 'baseApiService.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiService {
  @override
  Future<String> createPostApiResponse(String url, data) async {
    try {
      var request = http.MultipartRequest("post", Uri.parse(url));
      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        data["image"],
      );
      request.files.add(multipartFile);
      request.fields["title"] = data["title"];
      var resonse = await request.send();
      var resonseData = await resonse.stream.bytesToString();
      print("add post return: ${resonseData}");
      var idPost = jsonDecode(resonseData)["insertId"].toString();
      return idPost;
    } on SocketException {
      throw Exception("No internet Connection");
    } catch (e) {
      throw Exception("Error createPostApiResponse: $e");
    }
  }

  @override
  Future deleteByIdPostApiResponse(String url) async {
    try {
      final resonse = await http.delete(Uri.parse(url));
      return returnResponse(resonse);
    } on SocketException {
      throw Exception("No internet Connection");
    } catch (e) {
      throw Exception("Error deleteByIdPostApiResponse: $e");
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
    } on SocketException {
      throw Exception("No internet Connection");
    } catch (e) {
      throw Exception("Error getAllPostApiResponse: $e");
    }
  }

  @override
  Future<Post> getPostByIdApiResponse(String url) async {
    try {
      final resonse =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      var result = returnResponse(resonse);
      return Post.fromJson(result);
    } on SocketException {
      throw Exception("No internet Connection");
    } catch (e) {
      throw Exception("Error getPostByIdApiResponse: $e");
    }
  }

  @override
  Future updatePostApiResponse(String url, data) async {
    try {
      var request = http.MultipartRequest("put", Uri.parse(url));
      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        data["image"],
      );
      request.fields["id"] = data["id"].toString();
      request.files.add(multipartFile);
      request.fields["title"] = data["title"];
      await request.send();
    } on SocketException {
      throw Exception("No internet Connection");
    } catch (e) {
      throw Exception("Error updatePostApiResponse: $e");
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
