import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSavedProducts extends ProductListEvent {}

class ToggleSaveProduct extends ProductListEvent {
  final String productId;
  final bool isSaved;
  ToggleSaveProduct({required this.productId, required this.isSaved});

  @override
  List<Object?> get props => [productId, isSaved];
}
