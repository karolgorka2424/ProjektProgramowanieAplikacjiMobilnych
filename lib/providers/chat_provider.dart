import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Chat> _chats = [];
  List<Message> _currentMessages = [];
  bool _isLoading = false;

  // Getters
  List<Chat> get chats => _chats;
  List<Message> get currentMessages => _currentMessages;
  bool get isLoading => _isLoading;

  // Load all chats (posts)
  Future<void> loadChats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final posts = await _apiService.getPosts();

      // Transform posts to chats with additional fields
      _chats = posts.map((post) {
        return Chat(
          id: post.id,
          userId: post.userId,
          title: post.title,
          body: post.body,
          lastMessage: 'Tap to view messages',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
          unreadCount: 0,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error loading chats: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load messages for a specific chat (post)
  Future<void> loadMessages(int chatId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final comments = await _apiService.getComments(chatId);

      // Transform comments to messages with additional fields
      _currentMessages = comments.map((comment) {
        final now = DateTime.now();
        final random = now.subtract(Duration(minutes: comments.length - comments.indexOf(comment) * 5));

        return Message(
          postId: comment.postId,
          id: comment.id,
          name: comment.name,
          email: comment.email,
          body: comment.body,
          senderId: comment.email == 'user@example.com' ? 1 : (comment.postId % 10) + 2,
          timestamp: random.toIso8601String(),
          status: 'read',
        );
      }).toList();

      // Update last message in chat list
      final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1 && _currentMessages.isNotEmpty) {
        final lastMessage = _currentMessages.last;
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          lastMessage: lastMessage.body.length > 30
              ? '${lastMessage.body.substring(0, 30)}...'
              : lastMessage.body,
          lastMessageTime: lastMessage.timestamp,
          unreadCount: 0,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Error loading messages: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send a new message
  Future<void> sendMessage({
    required int postId,
    required String body,
    required String name,
    required String email,
    required int senderId,
  }) async {
    try {
      // Create message data
      final commentData = {
        'postId': postId,
        'name': name,
        'email': email,
        'body': body,
      };

      // Send to API
      final newComment = await _apiService.createComment(commentData);

      // Create a message from the comment
      final newMessage = Message(
        postId: newComment.postId,
        id: newComment.id,
        name: newComment.name,
        email: newComment.email,
        body: newComment.body,
        senderId: senderId,
        timestamp: DateTime.now().toIso8601String(),
        status: 'sent',
      );

      // Add to current messages
      _currentMessages.add(newMessage);

      // Update last message in chat list
      final chatIndex = _chats.indexWhere((chat) => chat.id == postId);
      if (chatIndex != -1) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          lastMessage: body.length > 30 ? '${body.substring(0, 30)}...' : body,
          lastMessageTime: DateTime.now().toIso8601String(),
        );
      }

      notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Create a new chat (post)
  Future<Chat> createChat({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      // Create post data
      final postData = {
        'userId': userId,
        'title': title,
        'body': body,
      };

      // Send to API
      final newPost = await _apiService.createPost(postData);

      // Create a chat from the post
      final newChat = Chat(
        id: newPost.id,
        userId: newPost.userId,
        title: newPost.title,
        body: newPost.body,
        lastMessage: 'Chat created',
        lastMessageTime: DateTime.now().toIso8601String(),
        unreadCount: 0,
      );

      // Add to chats list
      _chats.add(newChat);
      notifyListeners();

      return newChat;
    } catch (e) {
      print('Error creating chat: $e');
      rethrow;
    }
  }

  // Get a chat by ID
  Chat? getChatById(int chatId) {
    try {
      return _chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      return null;
    }
  }
}