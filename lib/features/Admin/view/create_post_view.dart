import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePostView extends StatefulWidget {
  final String? postId;

  const CreatePostView({super.key, this.postId});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _skinType;

  final Color primaryColor = const Color(0xFFA55166);

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      _fetchPost();
    }
  }

  Future<void> _fetchPost() async {
    try {
      final response = await http.get(
        Uri.parse('https://your-api-url.com/post/${widget.postId}'),
      );
      if (response.statusCode == 200) {
        final post = jsonDecode(response.body)['post'];
        setState(() {
          _titleController.text = post['title'];
          _descriptionController.text = post['description'];
          _imageUrlController.text = post['image'];
          _skinType = post['skin_type'];
        });
      } else {
        Fluttertoast.showToast(msg: "Error loading post");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to fetch post");
    }
  }

  Future<void> _handleSubmit() async {
    final data = jsonEncode({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'skin_type': _skinType,
      'image': _imageUrlController.text,
    });

    try {
      final url =
          widget.postId != null
              ? 'https://your-api-url.com/post/${widget.postId}'
              : 'https://your-api-url.com/post';
      final response =
          await (widget.postId != null
              ? http.put(
                Uri.parse(url),
                body: data,
                headers: {'Content-Type': 'application/json'},
              )
              : http.post(
                Uri.parse(url),
                body: data,
                headers: {'Content-Type': 'application/json'},
              ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: widget.postId != null ? "Post updated" : "Post created",
        );
        _titleController.clear();
        _descriptionController.clear();
        _imageUrlController.clear();
        setState(() {
          _skinType = null;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to submit post");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFfad1e3), Color(0x1Aff65aa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFA55166).withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create Post for SkinMusers",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Julius Sans One",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildInput("Post Title", _titleController),
                  const SizedBox(height: 16),
                  _buildTextArea("Description", _descriptionController),
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
                    child: const Text(
                      "Create Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Skin Type",
          style: const TextStyle(
            color: Colors.white,
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
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          style: const TextStyle(
            color: Colors.black, // keep dropdown text black for readability
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
