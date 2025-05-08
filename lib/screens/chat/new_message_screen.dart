import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/custom_text_field.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = true;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would load users from an API
      // For this demo, we'll use a mock list
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      setState(() {
        _users = List.generate(
          10,
              (index) => User(
            id: index + 1,
            name: 'User ${index + 1}',
            email: 'user${index + 1}@example.com',
            avatar: 'https://i.pravatar.cc/150?img=${index + 5}',
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load users: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createChat() async {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a user'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a chat title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.user == null) {
        throw Exception('User not authenticated');
      }

      final newChat = await chatProvider.createChat(
        userId: _selectedUser!.id,
        title: _titleController.text.trim(),
        body: _messageController.text.trim().isNotEmpty
            ? _messageController.text.trim()
            : 'Chat created',
      );

      if (mounted) {
        // Go to the new chat screen
        Navigator.pushReplacementNamed(
          context,
          '/chat',
          arguments: {
            'chatId': newChat.id,
            'title': newChat.title,
            'userId': newChat.userId,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create chat: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User selection dropdown
            DropdownButtonFormField<User>(
              decoration: const InputDecoration(
                labelText: 'Select User',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              value: _selectedUser,
              hint: const Text('Select a user to chat with'),
              items: _users.map((user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(user.avatar ?? ''),
                      ),
                      const SizedBox(width: 8),
                      Text(user.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (User? value) {
                setState(() {
                  _selectedUser = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Chat title field
            CustomTextField(
              controller: _titleController,
              labelText: 'Chat Title',
              hintText: 'Enter a title for this conversation',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),

            // First message field
            CustomTextField(
              controller: _messageController,
              labelText: 'First Message (Optional)',
              hintText: 'Type your first message',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Create chat button
            ElevatedButton(
              onPressed: _isCreating ? null : _createChat,
              child: _isCreating
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text('Start Conversation'),
            ),
          ],
        ),
      ),
    );
  }
}