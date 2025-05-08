import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  // Additional fields for our chat app
  int? senderId;
  String? timestamp;
  String? status;

  Message({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
    this.senderId,
    this.timestamp,
    this.status,
  });

  // Create from Comment API response
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  // Convert to JSON
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  // Create a Comment to send to API
  Map<String, dynamic> toCommentJson() {
    return {
      'postId': postId,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  // Create a mock message for chat
  factory Message.createMock({
    required int postId,
    required int id,
    required String body,
    required int senderId,
    required String senderName,
    required String senderEmail,
  }) {
    return Message(
      postId: postId,
      id: id,
      name: senderName,
      email: senderEmail,
      body: body,
      senderId: senderId,
      timestamp: DateTime.now().toIso8601String(),
      status: 'sent',
    );
  }

  // Check if message is from current user
  bool isFromCurrentUser(int currentUserId) {
    return senderId == currentUserId;
  }
}