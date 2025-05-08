import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final bool notifications;
  final bool messagePreview;
  final bool readReceipts;

  Settings({
    this.notifications = true,
    this.messagePreview = true,
    this.readReceipts = true,
  });

  Settings copyWith({
    bool? notifications,
    bool? messagePreview,
    bool? readReceipts,
  }) {
    return Settings(
      notifications: notifications ?? this.notifications,
      messagePreview: messagePreview ?? this.messagePreview,
      readReceipts: readReceipts ?? this.readReceipts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'messagePreview': messagePreview,
      'readReceipts': readReceipts,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      notifications: json['notifications'] ?? true,
      messagePreview: json['messagePreview'] ?? true,
      readReceipts: json['readReceipts'] ?? true,
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Settings _settings = Settings();

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Settings get settings => _settings;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme preference
    final themeIndex = prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    // Load settings
    final settingsString = prefs.getString('settings');
    if (settingsString != null) {
      try {
        _settings = Settings.fromJson(
          Map<String, dynamic>.from(
            const JsonDecoder().convert(settingsString),
          ),
        );
      } catch (e) {
        print('Error parsing settings: $e');
      }
    }

    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Save theme preference
    await prefs.setInt('theme_mode', _themeMode.index);

    // Save settings
    await prefs.setString(
      'settings',
      const JsonEncoder().convert(_settings.toJson()),
    );
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _savePreferences();
    notifyListeners();
  }

  void updateSettings({
    bool? notifications,
    bool? messagePreview,
    bool? readReceipts,
  }) {
    _settings = _settings.copyWith(
      notifications: notifications,
      messagePreview: messagePreview,
      readReceipts: readReceipts,
    );
    _savePreferences();
    notifyListeners();
  }
}