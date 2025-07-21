import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final ScrollController scrollController;
  final String currentUserId;

  const ProductDetailModal({
    Key? key,
    required this.product,
    required this.scrollController,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  List<dynamic> comments = [];
  final TextEditingController _commentController = TextEditingController();
  String editingCommentId = '';
  String editingText = '';

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> fetchComments() async {
    final postId = widget.product['_id'];
    final url = Uri.parse('http://10.0.2.2:3000/api/comments/post/$postId');
    final headers = await _getAuthHeaders();

    final res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> fetchedComments = jsonDecode(res.body);
      setState(() {
        comments = fetchedComments;
      });
    }
  }

  Future<void> submitComment() async {
    final postId = widget.product['_id'];
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final url = Uri.parse('http://10.0.2.2:3000/api/comments/$postId');
    final headers = await _getAuthHeaders();

    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'comment': text}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      _commentController.clear();
      fetchComments();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to post: ${res.body}")));
    }
  }

  Future<void> deleteComment(String commentId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/comments/$commentId');
    final headers = await _getAuthHeaders();

    final res = await http.delete(url, headers: headers);
    if (res.statusCode == 200) {
      fetchComments();
    }
  }

  Future<void> updateComment(String commentId, String text) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/comments/$commentId');
    final headers = await _getAuthHeaders();

    final res = await http.put(
      url,
      headers: headers,
      body: jsonEncode({'comment': text}),
    );

    if (res.statusCode == 200) {
      setState(() {
        editingCommentId = '';
        editingText = '';
      });
      fetchComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            product['title'] ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Image.network(product['image'] ?? '', height: 150),
          const SizedBox(height: 10),
          Text(product['description'] ?? ''),
          const Divider(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Comments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                comments.isEmpty
                    ? const Center(child: Text("No comments yet."))
                    : ListView.builder(
                      controller: widget.scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];

                        // Extract and compare user ID
                        final commentUser = comment['user'];
                        final commentUserId =
                            commentUser is Map
                                ? commentUser['_id']
                                : commentUser;
                        final isOwner = commentUserId == widget.currentUserId;
                        final authorName =
                            isOwner
                                ? 'You'
                                : (commentUser is Map
                                    ? commentUser['name'] ?? 'Unknown'
                                    : 'Unknown');

                        return IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                editingCommentId == comment['_id']
                                    ? Column(
                                      children: [
                                        TextField(
                                          onChanged: (val) => editingText = val,
                                          controller: TextEditingController(
                                            text: editingText,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: 'Edit your comment...',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed:
                                                  () => updateComment(
                                                    comment['_id'],
                                                    editingText,
                                                  ),
                                              child: const Text("Save"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => setState(() {
                                                    editingCommentId = '';
                                                    editingText = '';
                                                  }),
                                              child: const Text("Cancel"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                    : Text(
                                      comment['comment'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                if (isOwner &&
                                    editingCommentId != comment['_id'])
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            editingCommentId = comment['_id'];
                                            editingText = comment['comment'];
                                          });
                                        },
                                        child: const Text("Edit"),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => deleteComment(comment['_id']),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: submitComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
