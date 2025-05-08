import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final int id;
  final int userId;
  final String title;
  final String body;

  // Additional fields for our chat app
  String? lastMessage;
  String? lastMessageTime;
  int? unreadCount;

  Chat({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
  });

  // Create from Post API response
  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  // Convert to JSON
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  // Create a Post to send to API
  Map<String, dynamic> toPostJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  // Create a copy with new values
  Chat copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}