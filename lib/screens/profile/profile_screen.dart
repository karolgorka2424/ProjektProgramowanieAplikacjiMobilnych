import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.user?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final success = await Provider.of<AuthProvider>(context, listen: false)
          .updateProfile(name: _nameController.text.trim());

      if (success && mounted) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Edit/Save button
          _isEditing
              ? IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveProfile,
          )
              : IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Not signed in'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture
            Hero(
              tag: 'profile-picture',
              child: CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(user.avatar ?? ''),
              ),
            ),
            const SizedBox(height: 16),

            // Change profile picture button
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Change picture feature not implemented in this demo'),
                  ),
                );
              },
              child: const Text('Change Picture'),
            ),
            const SizedBox(height: 24),

            // User name
            _isEditing
                ? CustomTextField(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'Enter your name',
              keyboardType: TextInputType.name,
              autofocus: true,
            )
                : ListTile(
              title: const Text('Name'),
              subtitle: Text(
                user.name,
                style: const TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.person),
            ),

            // User email
            ListTile(
              title: const Text('Email'),
              subtitle: Text(
                user.email,
                style: const TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.email),
            ),

            // User ID
            ListTile(
              title: const Text('User ID'),
              subtitle: Text(
                '${user.id}',
                style: const TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.badge),
            ),

            const SizedBox(height: 24),

            // Save button
            if (_isEditing)
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Save Changes'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/chats');
          } else if (index == 1) {
            // Already on profile
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }
}