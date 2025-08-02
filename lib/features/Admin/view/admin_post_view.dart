import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:skin_muse/features/Products/view/product_view.dart';
import 'package:skin_muse/features/admin/ViewModel/admin_post_bloc.dart';
import 'package:skin_muse/features/admin/ViewModel/admin_post_event.dart';
import 'package:skin_muse/features/admin/ViewModel/admin_post_state.dart';


class AdminPostView extends StatefulWidget {
  final String userEmail;
  final String userId;

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
  String? _editingPostId;

  final Color primaryColor = const Color(0xFFA55166);

  @override
  void initState() {
    super.initState();
    context.read<AdminPostBloc>().add(FetchPosts());
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

  void _handleSubmit() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _skinType == null ||
        _imageUrlController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    if (_editingPostId == null) {
      context.read<AdminPostBloc>().add(
        CreatePost(
          title: _titleController.text,
          description: _descriptionController.text,
          skinType: _skinType!,
          image: _imageUrlController.text,
        ),
      );
      Fluttertoast.showToast(msg: "Post created");
    } else {
      context.read<AdminPostBloc>().add(
        UpdatePost(
          postId: _editingPostId!,
          title: _titleController.text,
          description: _descriptionController.text,
          skinType: _skinType!,
          image: _imageUrlController.text,
        ),
      );
      Fluttertoast.showToast(msg: "Post updated");
    }
    _clearForm();
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

  void _deletePost(String id) {
    context.read<AdminPostBloc>().add(DeletePost(id));
    Fluttertoast.showToast(msg: "Post deleted");
  }

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/login');
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminPostBloc, AdminPostState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          Fluttertoast.showToast(msg: state.errorMessage!);
        }
      },
      builder: (context, state) {
        final posts = state.posts;

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
                          _editingPostId == null
                              ? "Create Post"
                              : "Update Post",
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ProductView(skinType: ''),
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AdminPanelScreen(
                                    posts: posts,
                                    adminUserId: widget.userId,
                                    onDelete: _deletePost,
                                    onEdit: _editPost,
                                    refreshPosts: () async {
                                      context.read<AdminPostBloc>().add(
                                        FetchPosts(),
                                      );
                                    },
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
      },
    );
  }
}

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
                          onDelete(post['_id']);
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
