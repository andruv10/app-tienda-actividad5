class CartItem {
  final int id;
  final int productId;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String,
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      quantity: json['quantity'] as int,
    );
  }
}
