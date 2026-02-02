import 'package:get/get.dart';

import 'product_controller.dart';
import 'sales_controller.dart';

class DashboardController extends GetxController {
  final ProductController product = Get.find();
  final SalesController sales = Get.find();

  final totalProducts = 0.obs;
  final totalStock = 0.obs;
  final lowStock = 0.obs;
  final todaySales = 0.obs;
  final revenue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    _refresh();

    ever(product.products, (_) => _refresh());
    ever(sales.sales, (_) => _refresh());
  }

  void _refresh() {
    totalProducts.value = product.products.length;
    totalStock.value = product.totalStock();
    lowStock.value = product.lowStock().length;
    todaySales.value = sales.todaySalesCount();
    revenue.value = sales.totalRevenue();
  }
}
