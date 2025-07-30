import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/api_config.dart';
import 'package:skin_muse/features/Products/view/product_view.dart';
// import your ApiConfig

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _skinType;

  final Color primaryColor = const Color(0xFFA55166);

  Future<void> _handleSubmit() async {
    print("\n=== DEBUGGING POST CREATION ===");

    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _skinType == null ||
        _imageUrlController.text.isEmpty) {
      print("❌ Form validation failed");
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }
    print("✅ Form validation passed");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    print("\n🔑 Token Debug:");
    print("Token: '$token'");
    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(msg: "User not authenticated - no token found");
      return;
    }
    print("✅ Token found and valid");

    final baseUrl = await ApiConfig.baseUrl;
    final uri = Uri.parse("$baseUrl/post"); // replaced with ApiConfig

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
      print("\n📡 Sending request...");
      final response = await http.post(uri, body: data, headers: headers);

      print("\n📥 Response Debug:");
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Post created successfully!");
        _titleController.clear();
        _descriptionController.clear();
        _imageUrlController.clear();
        setState(() {
          _skinType = null;
        });
      } else {
        final errorData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: "Failed: ${errorData['message'] ?? response.statusCode}",
        );
      }
    } catch (e) {
      print("❌ Request exception: $e");
      Fluttertoast.showToast(msg: "Network error: $e");
    }

    print("=== END DEBUGGING ===\n");
  }

  Future<void> _testConnection() async {
    print("\n=== TESTING BACKEND CONNECTION ===");
    try {
      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.get(
        Uri.parse(baseUrl), // replaced with ApiConfig
      );
      print("✅ Connection test successful");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");
    } catch (e) {
      print("❌ Connection test failed: $e");
    }
    print("=== END CONNECTION TEST ===\n");
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
        title: const Text("Create Post for SkinMusers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.network_check),
            onPressed: _testConnection,
            tooltip: "Test Backend Connection",
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
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
                  child: const Text(
                    "Create Post",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
