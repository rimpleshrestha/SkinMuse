class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final String skinType;
  final String user;
  final List<dynamic> comments;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.skinType,
    required this.user,
    required this.comments,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      skinType: json['skin_type'],
      user: json['user'],
      comments: json['comments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image': image,
      'skin_type': skinType,
      'user': user,
      'comments': comments,
    };
  }
}
