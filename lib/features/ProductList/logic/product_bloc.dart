import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/ProductList/data/model/product_model.dart';
import 'package:skin_muse/features/ProductList/data/product_repository.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository repository;

  ProductListBloc(this.repository) : super(ProductListInitial()) {
    on<LoadSavedProducts>(_onLoadProducts);
    on<ToggleSaveProduct>(_onToggleSave);
  }

  Future<void> _onLoadProducts(
    LoadSavedProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      final products = await repository.fetchSavedProducts();
      emit(ProductListLoaded(products: products));
    } catch (e) {
      emit(ProductListError(message: e.toString()));
    }
  }

  Future<void> _onToggleSave(
    ToggleSaveProduct event,
    Emitter<ProductListState> emit,
  ) async {
    if (state is ProductListLoaded) {
      final currentState = (state as ProductListLoaded);
      final updatedProducts = List<ProductModel>.from(currentState.products);

      // Optimistic update: remove immediately if already saved
      updatedProducts.removeWhere((p) => p.id == event.productId);
      emit(ProductListLoaded(products: updatedProducts));

      try {
        if (event.isSaved) {
          await repository.unsaveProduct(event.productId);
        } else {
          await repository.saveProduct(event.productId);
        }
        // Re-fetch from server to ensure data is correct
        final refreshedProducts = await repository.fetchSavedProducts();
        emit(ProductListLoaded(products: refreshedProducts));
      } catch (e) {
        emit(ProductListError(message: e.toString()));
      }
    }
  }
}
