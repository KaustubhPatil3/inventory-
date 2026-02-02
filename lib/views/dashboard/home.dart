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
        title: const Text("Inventory Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: auth.logout,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await product.loadProducts();
          await sales.loadSales();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Obx(() => _statsCard()),
            const SizedBox(height: 20),
            _menuGrid(),
            const SizedBox(height: 20),
            _salesButton(),
          ],
        ),
      ),
    );
  }

  // ================= STATS =================

  Widget _statsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat("Products", product.products.length.toString()),
          _stat("Stock", product.totalStock().toString()),
          _stat("Value", "₹${product.totalValue().toStringAsFixed(0)}"),
          _stat("Today", sales.todaySalesCount().toString()),
        ],
      ),
    );
  }

  Widget _stat(String t, String v) {
    return Column(
      children: [
        Text(
          v,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(t, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  // ================= GRID =================

  Widget _menuGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      children: [
        _tile("Sell", Icons.shopping_cart, AppColors.primary,
            () => Get.toNamed('/sales')),
        _tile("Products", Icons.inventory, AppColors.secondary,
            () => Get.toNamed('/products')),
        _tile("Stock", Icons.store, Colors.green, () => Get.toNamed('/stock')),
        _tile("Low Stock", Icons.warning, AppColors.danger,
            () => Get.toNamed('/low-stock')),
        _tile("Settings", Icons.settings, Colors.grey,
            () => Get.toNamed('/settings')),
      ],
    );
  }

  Widget _tile(String t, IconData i, Color c, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(Get.context!).cardColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: c.withOpacity(.15),
              child: Icon(i, color: c),
            ),
            const SizedBox(height: 10),
            Text(t, style: const TextStyle(fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }

  // ================= BUTTON =================

  Widget _salesButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.history),
        label: const Text("Sales History"),
        onPressed: () => Get.toNamed('/sales-history'),
      ),
    );
  }
}
