import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_view_model.dart';
import 'package:skin_muse/features/Products/remote_datasource/product_remote_data_source.dart';
import 'product_event.dart';
import 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductViewModel _viewModel = ProductViewModel(remoteDataSource: ProductRemoteDataSource());

  ProductBloc() : super(ProductInitial()) {
    on<LoadProductsBySkinType>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await _viewModel.fetchProductsBySkinType(
          event.skinType,
        );
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to load products'));
      }
    });
  }
}
