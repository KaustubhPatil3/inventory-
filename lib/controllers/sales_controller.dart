import 'package:get/get.dart';
import '../models/sale_model.dart';
import '../services/storage_service.dart';
import 'product_controller.dart';

class SalesController extends GetxController {
  final StorageService storage = StorageService();
  final ProductController product = Get.find<ProductController>();

  var sales = <SaleModel>[].obs;

  @override
  void onInit() {
    loadSales();
    super.onInit();
  }

  Future<void> loadSales() async {
    sales.value = await storage.getSales();
  }

  Future<void> createSale(String productId, String name, int qty) async {
    final sale = SaleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: productId,
      productName: name,
      quantity: qty,
      date: DateTime.now().toIso8601String(),
    );

    sales.add(sale);
    await storage.saveSales(sales.toList());

    product.reduceStock(productId, qty);
  }

  // ================= DASHBOARD HELPERS =================

  int todaySalesCount() {
    final today = DateTime.now().toIso8601String().split('T').first;

    return sales.where((s) => s.date.startsWith(today)).length;
  }

  int totalItemsSold() {
    return sales.fold(0, (sum, s) => sum + s.quantity);
  }

  void clearSales() {
    sales.clear();
  }
}
