import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/ProductList/logic/product_bloc.dart';
import 'package:skin_muse/features/ProductList/logic/product_list_event.dart';
import 'package:skin_muse/features/ProductList/logic/product_list_state.dart';
import 'package:skin_muse/features/ProductList/data/product_repository.dart';
import 'package:dio/dio.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

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
                  return GestureDetector(
                    onTap: () {
                      // open modal or product detail screen if you have one
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
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
                              textAlign: TextAlign.center,
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
