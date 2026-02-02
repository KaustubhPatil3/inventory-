class SaleModel {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double price; // NEW
  final DateTime date;

  SaleModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.date,
  });

  // ================= COPY =================

  SaleModel copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? price,
    DateTime? date,
  }) {
    return SaleModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      date: date ?? this.date,
    );
  }

  // ================= JSON =================

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "date": date.toIso8601String(),
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }
}
