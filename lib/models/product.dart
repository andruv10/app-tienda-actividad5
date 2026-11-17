class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int categoryId;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String?,
    );
  }
}
