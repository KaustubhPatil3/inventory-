import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/storage_service.dart';

class ProductController extends GetxController {
  final StorageService storage = StorageService();

  final products = <ProductModel>[].obs;

  ProductModel? _lastDeleted;

  @override
  void onInit() {
    super.onInit();

    loadProducts();

    // Auto save
    ever(products, (_) => _save());

    // Low stock alert
    ever(products, (_) {
      final low = lowStock();

      if (low.isNotEmpty) {
        Get.snackbar(
          "Low Stock",
          "${low.length} products are low",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  // ================= LOAD =================

  Future<void> loadProducts() async {
    try {
      final data = await storage.getProducts();
      products.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Cannot load products");
    }
  }

  // ================= ADD =================

  Future<void> addProduct(ProductModel p) async {
    products.add(p);
  }

  // ================= UPDATE =================

  Future<void> updateProduct(ProductModel p) async {
    final i = products.indexWhere((e) => e.id == p.id);

    if (i != -1) {
      products[i] = p;
      products.refresh();
    }
  }

  // ================= DELETE =================

  Future<void> deleteProduct(String id) async {
    _lastDeleted = products.firstWhereOrNull((e) => e.id == id);

    products.removeWhere((e) => e.id == id);
  }

  // ================= UNDO =================

  void undoDelete() {
    if (_lastDeleted != null) {
      products.add(_lastDeleted!);
      _lastDeleted = null;
    }
  }

  // ================= STOCK =================

  bool reduceStock(String id, int qty) {
    final i = products.indexWhere((e) => e.id == id);

    if (i == -1) return false;

    if (products[i].stock < qty) {
      Get.snackbar("Error", "Not enough stock");
      return false;
    }

    products[i] = products[i].copyWith(stock: products[i].stock - qty);

    products.refresh();

    return true;
  }

  void increaseStock(String id, int qty) {
    final i = products.indexWhere((e) => e.id == id);

    if (i == -1) return;

    products[i] = products[i].copyWith(stock: products[i].stock + qty);

    products.refresh();
  }

  // ================= SAVE =================

  Future<void> _save() async {
    await storage.saveProducts(products.toList());
  }

  // ================= HELPERS =================

  int totalStock() {
    return products.fold(0, (s, p) => s + p.stock);
  }

  double totalValue() {
    return products.fold(0, (s, p) => s + (p.price * p.stock));
  }

  List<ProductModel> lowStock({int limit = 5}) {
    return products.where((p) => p.stock <= limit).toList();
  }

  ProductModel? findById(String id) {
    return products.firstWhereOrNull((e) => e.id == id);
  }
}
