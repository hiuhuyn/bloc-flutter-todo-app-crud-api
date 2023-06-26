import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_fontend/bloc/bloc/post_bloc.dart';
import 'package:flutter_app_fontend/bloc/event/post_event.dart';
import 'package:flutter_app_fontend/bloc/state/post_state.dart';
import 'package:flutter_app_fontend/utils/app_url.dart';
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
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PostBloc>().add(GetAllPostEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo app"),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<PostBloc>(context).add(GetAllPostEvent());
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PostLoadingState:
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              ));

            case PostErrorState:
              var stateErr = state as PostErrorState;
              return Column(
                children: [
                  const Icon(Icons.error_outline, size: 30),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Error: ${stateErr.error}",
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ],
              );
            default:
              return fetchingSuccessFull(state);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context, "THÊM POST", () async {
            await pickImageFromGallery().then((value) {
              Post post = Post(image: value, title: controller.text);
              context.read<PostBloc>().add(AddPostEvent(post: post));
              controller.clear();
              Navigator.pop(context);
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget fetchingSuccessFull(PostState state) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: state.posts.isNotEmpty ? state.posts.length : 0,
        itemBuilder: (context, index) {
          return itemPost(state.posts[index]);
        },
      ),
    );
  }

  Widget itemPost(Post post) {
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
                "${post.id}\n${post.title}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  height: 200,
                  width: 300,
                  margin: const EdgeInsets.all(10),
                  child: FittedBox(child: imagePost(post.image))),
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<PostBloc>(context)
                        .add(DeletePostEvent(id: post.id!));
                  },
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    controller.text = post.title;
                    _showBottomSheet(context, "Cập nhật", () async {
                      await pickImageFromGallery().then((value) {
                        post =
                            post.copyWith(image: value, title: controller.text);
                        context
                            .read<PostBloc>()
                            .add(UpdatePostEvent(post: post));
                        controller.clear();
                        Navigator.pop(context);
                      });
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
    try {
      if (image.isNotEmpty) {
        return Image.network(
          AppUrl.baseUrl + image,
        );
      } else {
        throw Exception("Image is empty");
      }
    } catch (e) {
      print("Loading image failed: $e");
      return const Placeholder();
    }
  }

  void _showBottomSheet(BuildContext ctx, String title, VoidCallback onPress) {
    try {
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
    } catch (e) {
      print("Error while _showBottomSheet: $e");
    }
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
