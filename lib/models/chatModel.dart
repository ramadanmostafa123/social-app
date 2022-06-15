// ignore_for_file: file_names

class MessageModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? dateTime;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.text,
    this.dateTime,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    text = json!['text'];
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    receiverId = json['receiverId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'dateTiime ': dateTime,
    };
  }
}
