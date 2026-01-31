import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../theme/app_colors.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final auth = Get.find<AuthController>();
  final product = Get.find<ProductController>();
  final sales = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: auth.logout),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _topStats(),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [
                    _tile("Sell", Icons.shopping_cart, AppColors.primary,
                        () => Get.toNamed('/sales')),
                    _tile("Products", Icons.inventory, AppColors.secondary,
                        () => Get.toNamed('/products')),
                    _tile("Stock", Icons.store, Colors.green,
                        () => Get.toNamed('/stock')),
                    _tile("Low Stock", Icons.warning, AppColors.danger,
                        () => Get.toNamed('/low-stock')),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text("Sales History"),
                  onPressed: () => Get.toNamed('/sales-history'),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _topStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat("Products", product.products.length),
          _stat("Stock", product.totalStock()),
          _stat("Today", sales.todaySalesCount()),
        ],
      ),
    );
  }

  Widget _stat(String t, int v) {
    return Column(
      children: [
        Text(v.toString(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(t, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _tile(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(Get.context!).cardColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
