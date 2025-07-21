import 'package:flutter/material.dart';

class ProductDetailModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final ScrollController scrollController;

  const ProductDetailModal({
    Key? key,
    required this.product,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  late List<dynamic> comments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    comments = List.from(widget.product['comments'] ?? []);
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      comments.add(text);
      _commentController.clear();
    });

    // TODO: Integrate comment send logic with backend
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product['image'] ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product['description'] ?? ''),
            const Divider(height: 32),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (comments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No comments yet.'),
              )
            else
              ...comments.map(
                (c) => ListTile(
                  leading: const Icon(Icons.comment),
                  title: Text(c.toString()),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
