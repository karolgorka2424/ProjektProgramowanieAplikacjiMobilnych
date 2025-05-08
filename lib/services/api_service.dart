import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    contentType: 'application/json; charset=utf-8',
  ));

  // Get all users
  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      final users = (response.data as List)
          .map((data) => User.fromJson(data))
          .toList();
      return users;
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  // Get a specific user
  Future<User> getUser(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  // Get all posts (chats)
  Future<List<Chat>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      final posts = (response.data as List)
          .map((data) => Chat.fromJson(data))
          .toList();
      return posts;
    } catch (e) {
      print('Error getting posts: $e');
      rethrow;
    }
  }

  // Get user posts
  Future<List<Chat>> getUserPosts(int userId) async {
    try {
      final response = await _dio.get('/posts', queryParameters: {
        'userId': userId,
      });
      final posts = (response.data as List)
          .map((data) => Chat.fromJson(data))
          .toList();
      return posts;
    } catch (e) {
      print('Error getting user posts: $e');
      rethrow;
    }
  }

  // Create a new post (chat)
  Future<Chat> createPost(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/posts', data: data);
      return Chat.fromJson(response.data);
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  // Get comments for a post (messages in a chat)
  Future<List<Message>> getComments(int postId) async {
    try {
      final response = await _dio.get('/posts/$postId/comments');
      final comments = (response.data as List)
          .map((data) => Message.fromJson(data))
          .toList();
      return comments;
    } catch (e) {
      print('Error getting comments: $e');
      rethrow;
    }
  }

  // Create a new comment (send a message)
  Future<Message> createComment(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/comments', data: data);
      return Message.fromJson(response.data);
    } catch (e) {
      print('Error creating comment: $e');
      rethrow;
    }
  }
}