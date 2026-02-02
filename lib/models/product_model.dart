class ProductModel {
  String id;
  String name;
  String category;
  double price;
  int stock;
  String createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    int? stock,
    String? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "price": price,
      "stock": stock,
      "createdAt": createdAt,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      stock: json['stock'],
      createdAt: json['createdAt'],
    );
  }
}
