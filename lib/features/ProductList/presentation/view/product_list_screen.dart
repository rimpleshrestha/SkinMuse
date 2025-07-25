import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/ProductList/logic/product_bloc.dart';
import '../../logic/product_list_event.dart';
import '../../logic/product_list_state.dart';
import '../../data/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:skin_muse/features/Products/view/product_detail_modal.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  void _openDetails(BuildContext context, Map<String, dynamic> product) {
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
                  product: product,
                  scrollController: scrollController,
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              ProductListBloc(ProductRepository(Dio()))
                ..add(LoadSavedProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("🌿 Your Product List"),
          backgroundColor: Colors.pink[100],
        ),
        body: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductListLoaded) {
              if (state.products.isEmpty) {
                return const Center(
                  child: Text(
                    "No products added to the list yet.",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  final productMap = {
                    "_id": product.id,
                    "image": product.image,
                    "title": product.title,
                    "description": product.description,
                    "skin_type": product.skinType,
                    "isSaved": true,
                  };

                  return GestureDetector(
                    onTap: () => _openDetails(context, productMap),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              product.image,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              product.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              context.read<ProductListBloc>().add(
                                ToggleSaveProduct(
                                  productId: product.id,
                                  isSaved: true,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductListError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
