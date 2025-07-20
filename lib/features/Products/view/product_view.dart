import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_bloc.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_event.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_state.dart';


class ProductView extends StatelessWidget {
  final String skinType;

  const ProductView({super.key, required this.skinType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products for $skinType'), centerTitle: true),
      body: BlocProvider(
        create:
            (context) => ProductBloc()..add(LoadProductsBySkinType(skinType)),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              if (state.products.isEmpty) {
                return const Center(child: Text('No products found'));
              }
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.network(
                        product['image'] ?? '',
                        height: 50,
                        width: 50,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.image_not_supported),
                      ),
                      title: Text(product['name'] ?? 'No name'),
                      subtitle: Text(
                        product['description'] ?? 'No description',
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Select a skin type'));
            }
          },
        ),
      ),
    );
  }
}
