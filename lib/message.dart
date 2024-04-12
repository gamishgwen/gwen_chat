import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String senderImage;
  final String senderUserName;
  final String message;
  final DateTime time;

  Message(
      {String? messageId,
      required this.senderId,
      required this.senderImage,
      required this.senderUserName,
      required this.message,
      required this.time})
      : id = messageId ?? FirebaseFirestore.instance.collection('xyz').doc().id;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderImage': senderImage,
      'senderUserName': senderUserName,
      'message': message,
      'time': time
    };
  }

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
        messageId: map['id'],
        senderId: map['senderId'],
        senderImage: map['senderImage'],
        senderUserName: map['senderUserName'],
        message: map['message'],
        time: (map['time'] as Timestamp).toDate());
  }
}
