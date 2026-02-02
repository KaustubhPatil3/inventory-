import 'package:get/get.dart';

import '../models/sale_model.dart';
import '../services/storage_service.dart';
import 'product_controller.dart';

class SalesController extends GetxController {
  final StorageService storage = StorageService();
  final ProductController product = Get.find();

  final sales = <SaleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSales();
  }

  // ================= LOAD =================

  Future<void> loadSales() async {
    try {
      final data = await storage.getSales();
      sales.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Cannot load sales");
    }
  }

  // ================= CREATE =================

  Future<bool> createSale(String productId, String name, int qty) async {
    if (qty <= 0) {
      Get.snackbar("Error", "Invalid quantity");
      return false;
    }

    final p = product.findById(productId);

    if (p == null) {
      Get.snackbar("Error", "Product not found");
      return false;
    }

    final ok = product.reduceStock(productId, qty);

    if (!ok) return false;

    final sale = SaleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: productId,
      productName: name,
      quantity: qty,
      price: p.price,
      date: DateTime.now(),
    );

    sales.add(sale);

    await storage.saveSales(sales.toList());

    return true;
  }

  // ================= DELETE =================

  Future<void> deleteSale(String id) async {
    sales.removeWhere((e) => e.id == id);
    await storage.saveSales(sales.toList());
  }

  // ================= CLEAR =================

  Future<void> clearSales() async {
    sales.clear();
    await storage.saveSales([]);
  }

  // ================= HELPERS =================

  int todaySalesCount() {
    final today = DateTime.now().toIso8601String().split('T').first;

    return sales
        .where(
          (s) => s.date.toIso8601String().startsWith(today),
        )
        .length;
  }

  int totalItemsSold() {
    return sales.fold(0, (s, e) => s + e.quantity);
  }

  double totalRevenue() {
    return sales.fold(0, (s, e) => s + (e.price * e.quantity));
  }

  Map<String, int> monthlySales() {
    final map = <String, int>{};

    for (final s in sales) {
      final m = s.date.toIso8601String().substring(0, 7);

      map[m] = (map[m] ?? 0) + s.quantity;
    }

    return map;
  }
}
