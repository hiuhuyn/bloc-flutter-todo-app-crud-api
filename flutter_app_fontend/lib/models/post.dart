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

  String get imageUrl {
    var listString = image.split('/');
    if (listString.first == 'http:' || listString.first == 'https:') {
      return image;
    } else {
      return "";
    }
  }
}
