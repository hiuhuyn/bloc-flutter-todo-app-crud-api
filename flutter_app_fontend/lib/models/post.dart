// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  int? id;
  String title = "";
  String image = "";

  Post({this.id, required this.title, required this.image});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }

  Post copyWith({
    int? id,
    String? title,
    String? image,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  @override
  String toString() => 'Post(id: $id, title: $title, image: $image)';
}
