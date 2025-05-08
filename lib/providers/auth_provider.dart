import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  // Mock users for demo
  final List<UserWithPassword> _mockUsers = [
    UserWithPassword(
      id: 1,
      name: 'John Doe',
      email: 'user@example.com',
      password: 'password123',
      avatar: 'https://i.pravatar.cc/150?img=1',
    ),
    UserWithPassword(
      id: 2,
      name: 'Jane Smith',
      email: 'test@example.com',
      password: 'test123',
      avatar: 'https://i.pravatar.cc/150?img=2',
    ),
  ];

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initUser();
  }

  // Initialize user from SharedPreferences
  Future<void> _initUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString != null) {
      try {
        final userData = json.decode(userString);
        _user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          avatar: userData['avatar'],
        );
      } catch (e) {
        print('Error parsing user data: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      // Find user with matching credentials
      final foundUser = _mockUsers.firstWhere(
            (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );

      // Convert to User without password
      _user = foundUser.toUser();

      // Save user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode({
        'id': _user!.id,
        'name': _user!.name,
        'email': _user!.email,
        'avatar': _user!.avatar,
      }));

      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register new user
  Future<bool> register(String name, String email, String password) async {
    try {
      // Check if user already exists
      final userExists = _mockUsers.any((user) => user.email == email);

      if (userExists) {
        throw Exception('Email already registered');
      }

      // Create new user
      final newUser = UserWithPassword(
        id: _mockUsers.length + 1,
        name: name,
        email: email,
        password: password,
      );

      // Add to mock users
      _mockUsers.add(newUser);

      // Set as current user (without password)
      _user = newUser.toUser();

      // Save user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode({
        'id': _user!.id,
        'name': _user!.name,
        'email': _user!.email,
        'avatar': _user!.avatar,
      }));

      notifyListeners();
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _user = null;

    // Clear user from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({String? name, String? avatar}) async {
    if (_user == null) return false;

    try {
      // Update local user object
      _user = User(
        id: _user!.id,
        name: name ?? _user!.name,
        email: _user!.email,
        avatar: avatar ?? _user!.avatar,
      );

      // Update in mock users
      final userIndex = _mockUsers.indexWhere((user) => user.id == _user!.id);
      if (userIndex != -1) {
        _mockUsers[userIndex] = UserWithPassword(
          id: _user!.id,
          name: name ?? _user!.name,
          email: _user!.email,
          password: _mockUsers[userIndex].password,
          avatar: avatar ?? _user!.avatar,
        );
      }

      // Save updated user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode({
        'id': _user!.id,
        'name': _user!.name,
        'email': _user!.email,
        'avatar': _user!.avatar,
      }));

      notifyListeners();
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}