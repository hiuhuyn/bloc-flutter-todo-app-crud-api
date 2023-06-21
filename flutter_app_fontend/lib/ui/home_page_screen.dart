import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_fontend/bloc/bloc/post_bloc.dart';
import 'package:flutter_app_fontend/bloc/event/post_event.dart';
import 'package:flutter_app_fontend/bloc/state/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/post.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final PostBloc postBloc = PostBloc();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postBloc.add(GetAllPostEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo app"),
        actions: [
          IconButton(
              onPressed: () {
                postBloc.add(GetAllPostEvent());
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        bloc: postBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PostsFetchingLoadingState:
              return const Center(child: CircularProgressIndicator());
            case PostFetchingSuccessfulState:
              return fetchingSuccessFull(state as PostFetchingSuccessfulState);
            case PostsFetchingErrorState:
              return const Center(
                child: Icon(Icons.error),
              );
            default:
              return Container(
                color: Colors.amber,
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context, "THÊM POST", () async {
            await pickImageFromGallery().then((value) {
              Post post = Post(image: value, title: controller.text);
              postBloc.add(AddPostEvent(post: post));
              controller.clear();
              Future.delayed(const Duration(seconds: 2));
              postBloc.add(GetAllPostEvent());
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget fetchingSuccessFull(PostFetchingSuccessfulState state) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: state.posts.isNotEmpty ? state.posts.length : 0,
        itemBuilder: (context, index) {
          return itemPost(state, index);
        },
      ),
    );
  }

  Widget itemPost(PostFetchingSuccessfulState state, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.grey),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, offset: const Offset(5, 5))
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${state.posts[index].id}\n${state.posts[index].title}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  height: 200,
                  width: 300,
                  margin: const EdgeInsets.all(10),
                  child:
                      FittedBox(child: imagePost(state.posts[index].imageUrl))),
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    postBloc.add(DeletePostEvent(id: state.posts[index].id!));
                    state.posts.removeAt(index);
                  },
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    controller.text = state.posts[index].title;
                    _showBottomSheet(context, "Cập nhật", () async {
                      await pickImageFromGallery().then((value) {
                        Post post = Post(
                            id: state.posts[index].id,
                            image: value,
                            title: controller.text);
                        postBloc.add(UpdatePostEvent(post: post));
                      });
                      controller.clear();
                      await Future.delayed(const Duration(seconds: 2));
                      postBloc.add(GetAllPostEvent());
                    });
                  },
                  icon: const Icon(Icons.edit))
            ],
          )
        ],
      ),
    );
  }

  Widget imagePost(String image) {
    if (image != "") {
      return Image.network(
        image,
      );
    }
    return Placeholder();
  }

  void _showBottomSheet(BuildContext ctx, String title, VoidCallback onPress) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: 'Tiêu đề',
                        labelText: 'Tiêu đề',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                ElevatedButton(onPressed: onPress, child: Text(title))
              ],
            ));
  }

  Future<String> pickImageFromGallery() async {
    String _pathImage = "";
    try {
      final _pickker = ImagePicker();
      var status = await Permission.camera.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        if (await Permission.camera.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          print("Permisssion was granted");
          await _pickker.pickImage(source: ImageSource.gallery).then((value) {
            if (value != null) {
              _pathImage = value.path;
              print(value.path);
            }
          });
        } else {
          print("is granted false");
        }
      } else if (status.isGranted) {
        print("Permission isGranted");
        await _pickker.pickImage(source: ImageSource.gallery).then((value) {
          if (value != null) {
            _pathImage = value.path;
            print(value.path);
          }
        });
      }
    } on PlatformException catch (e) {
      print("PlatformException pickImageFromGallery: $e");
    } catch (e) {
      print("Exceptioin pickImageFromGallery catch: $e");
    }
    return _pathImage;
  }
}
