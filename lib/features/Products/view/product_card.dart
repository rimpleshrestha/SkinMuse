import 'package:flutter/material.dart';
import 'package:skin_muse/features/Products/view/product_detail_modal.dart';
import 'package:skin_muse/features/ProductList/data/product_repository.dart';
import 'package:dio/dio.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isSaved = false;
  late final ProductRepository repository;

  @override
  void initState() {
    super.initState();
    repository = ProductRepository(Dio());
    isSaved = widget.product['isSaved'] ?? false; // initial state from backend
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.pink.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _toggleSave() async {
    final productId = widget.product['_id'];
    if (productId == null) return;

    setState(() => isSaved = !isSaved);

    try {
      if (isSaved) {
        await repository.saveProduct(productId);
        _showSnackBar("Product is saved!");
      } else {
        await repository.unsaveProduct(productId);
        _showSnackBar("Product is unsaved!");
      }
    } catch (e) {
      setState(() => isSaved = !isSaved); // revert on failure
      debugPrint("❌ Error saving/unsaving product: $e");
    }
  }

  void _openDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => ProductDetailModal(
                  product: widget.product,
                  scrollController: scrollController,
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    if (product.isEmpty) return const SizedBox();

    return GestureDetector(
      onTap: _openDetails,
      child: SizedBox(
        height: 280,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product['image'] ?? '',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    product['description'] ?? 'No Description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Skin: ${product['skin_type'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.pink,
                      ),
                      onPressed: _toggleSave,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
