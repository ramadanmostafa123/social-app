// ignore_for_file: file_names

class PostModel {
  String? name;
  String? image;
  String? text;
  String? uId;
  String? postImage;
  String? dateTime;

  PostModel({
    this.image,
    this.name,
    this.text,
    this.uId,
    this.postImage,
    this.dateTime,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    text = json!['text'];
    name = json['name'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'postImage': postImage,
      'text': text,
      'uId ': uId,
      'image': image,
      'dateTime': dateTime,
    };
  }
}
