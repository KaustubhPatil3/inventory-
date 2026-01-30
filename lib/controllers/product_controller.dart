import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/storage_service.dart';

class ProductController extends GetxController {
  final StorageService storage = StorageService();

  var products = <ProductModel>[].obs;

  @override
  void onInit() {
    loadProducts();
    super.onInit();
  }

  void loadProducts() async {
    products.value = await storage.getProducts();
  }

  void addProduct(ProductModel product) async {
    products.add(product);
    await storage.saveProducts(products);
  }

  void deleteProduct(String id) async {
    products.removeWhere((p) => p.id == id);
    await storage.saveProducts(products);
  }

  int totalStock() {
    return products.fold(0, (sum, p) => sum + p.stock);
  }

  void reduceStock(String id, int qty) async {
    final index = products.indexWhere((p) => p.id == id);
    if (index == -1) return;

    products[index].stock -= qty;
    await storage.saveProducts(products);
  }

  List<ProductModel> lowStock() {
    return products.where((p) => p.stock < 10).toList();
  }

  void updateProduct(ProductModel p) async {
    final index = products.indexWhere((e) => e.id == p.id);
    if (index == -1) return;

    products[index] = p;
    await storage.saveProducts(products.toList());
  }
}
