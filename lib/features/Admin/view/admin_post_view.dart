import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skin_muse/api_config.dart';
import 'package:skin_muse/features/Products/view/product_view.dart';

class AdminPostView extends StatefulWidget {
  final String userEmail;
  final String userId; // extracted from token 'id'

  const AdminPostView({
    super.key,
    required this.userEmail,
    required this.userId,
  });

  @override
  State<AdminPostView> createState() => _AdminPostViewState();
}

class _AdminPostViewState extends State<AdminPostView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _skinType;

  final Color primaryColor = const Color(0xFFA55166);

  List<dynamic> _posts = [];
  String? _editingPostId;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _fetchPosts() async {
    try {
      final token = await _getToken();
      if (token == null) {
        Fluttertoast.showToast(msg: "Not authenticated");
        return;
      }

      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.get(
        Uri.parse("$baseUrl/post"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _posts = decoded['posts'] ?? [];
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch posts");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching posts: $e");
    }
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _skinType == null ||
        _imageUrlController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    final token = await _getToken();
    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(msg: "User not authenticated - no token found");
      return;
    }

    final baseUrl = await ApiConfig.baseUrl;
    final uri =
        _editingPostId == null
            ? Uri.parse("$baseUrl/post")
            : Uri.parse("$baseUrl/post/$_editingPostId");

    final data = jsonEncode({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'skin_type': _skinType,
      'image': _imageUrlController.text,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response =
          _editingPostId == null
              ? await http.post(uri, body: data, headers: headers)
              : await http.put(uri, body: data, headers: headers);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: _editingPostId == null ? "Post created" : "Post updated",
        );
        _clearForm();
        _fetchPosts();
      } else {
        final errorData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: "Failed: ${errorData['message'] ?? response.statusCode}",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error: $e");
    }
  }

  Future<void> _deletePost(String id) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(msg: "User not authenticated");
      return;
    }

    final baseUrl = await ApiConfig.baseUrl;
    final uri = Uri.parse("$baseUrl/post/$id");

    try {
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Post deleted");
        _fetchPosts();
      } else {
        Fluttertoast.showToast(msg: "Failed to delete post");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting post: $e");
    }
  }

  void _editPost(Map<String, dynamic> post) {
    setState(() {
      _editingPostId = post['_id'];
      _titleController.text = post['title'] ?? '';
      _descriptionController.text = post['description'] ?? '';
      _imageUrlController.text = post['image'] ?? '';
      _skinType = post['skin_type'];
    });
  }

  void _clearForm() {
    setState(() {
      _editingPostId = null;
      _titleController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
      _skinType = null;
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint("🔒 Admin logged out, shared prefs cleared");

    if (mounted) {
      Navigator.of(context).pop(); // remove dialog
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA55166),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Skin Type",
          style: TextStyle(
            color: Color(0xFFA55166),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _skinType,
          items: const [
            DropdownMenuItem(value: "Oily", child: Text("Oily")),
            DropdownMenuItem(value: "Dry", child: Text("Dry")),
            DropdownMenuItem(value: "Combination", child: Text("Combination")),
            DropdownMenuItem(value: "Normal", child: Text("Normal")),
          ],
          onChanged: (value) => setState(() => _skinType = value),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfad1e3),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Manage Posts"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Form Section
            Container(
              width: 600,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInput("Post Title", _titleController),
                  const SizedBox(height: 16),
                  _buildInput("Description", _descriptionController),
                  const SizedBox(height: 16),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  _buildInput("Image URL", _imageUrlController),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _editingPostId == null ? "Create Post" : "Update Post",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_editingPostId != null)
                    TextButton(
                      onPressed: _clearForm,
                      child: const Text("Cancel Edit"),
                    ),
                  const SizedBox(height: 16),

                  // Button: Go to Product View
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductView(skinType: ''),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Go to Product View",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // NEW BUTTON: Admin Panel
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AdminPanelScreen(
                                posts: _posts,
                                adminUserId: widget.userId,
                                onDelete: _deletePost,
                                onEdit: _editPost,
                                refreshPosts: _fetchPosts,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Admin Panel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // NEW BUTTON: Logout for Admin
                  ElevatedButton(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New Admin Panel Screen to show posts list with edit and delete buttons
class AdminPanelScreen extends StatelessWidget {
  final List<dynamic> posts;
  final String adminUserId;
  final Function(String) onDelete;
  final Function(Map<String, dynamic>) onEdit;
  final Future<void> Function() refreshPosts;

  const AdminPanelScreen({
    super.key,
    required this.posts,
    required this.adminUserId,
    required this.onDelete,
    required this.onEdit,
    required this.refreshPosts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel - Posts"),
        backgroundColor: const Color(0xFFA55166),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPosts,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final postOwnerId = post['user']?.toString() ?? '';

            if (postOwnerId != adminUserId) {
              // Skip posts not owned by admin user
              return const SizedBox.shrink();
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(post['title'] ?? ''),
                subtitle: Text("Skin Type: ${post['skin_type']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        onEdit(post);
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                  "Are you sure you want to delete this post?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                        );
                        if (confirmed == true) {
                          await onDelete(post['_id']);
                          await refreshPosts();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
