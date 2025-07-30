import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:skin_muse/features/ProductList/presentation/view/product_list_screen.dart';

import 'package:skin_muse/features/Products/product_viewmodel/product_bloc.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_event.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_model.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_state.dart';
import 'package:skin_muse/features/Products/view/product_card.dart';


class ProductView extends StatefulWidget {
  final String skinType;
  const ProductView({super.key, required this.skinType});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late ProductBloc _productBloc;
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc();
    _productBloc.add(LoadProductsBySkinType(widget.skinType));

    _shakeDetector = ShakeDetector.autoStart(onPhoneShake: _onShake);
  }

  void _onShake(ShakeEvent event) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProductListScreen()));
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfad1e3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA55166),
        title: const Text(
          "Recommended for you",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        bloc: _productBloc,
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final List<Product> products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text("No products found."));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final map = product.toJson();

                if (map['title'] == null || map['description'] == null) {
                  return const SizedBox();
                }

                return ProductCard(product: map);
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
