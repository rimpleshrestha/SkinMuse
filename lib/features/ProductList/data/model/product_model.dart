class ProductModel {
  final String id;
  final String title;
  final String description;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '', // ✅ Use MongoDB _id
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  get skinType => null;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
