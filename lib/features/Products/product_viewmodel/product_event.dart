abstract class ProductEvent {}

class LoadProductsBySkinType extends ProductEvent {
  final String skinType;

  LoadProductsBySkinType(this.skinType);
}
