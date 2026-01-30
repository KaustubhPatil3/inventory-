import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthController auth = Get.find<AuthController>();
  final ProductController product = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: auth.logout,
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _card("Products", product.products.length, Icons.inventory,
                        Colors.blue),
                    _card("Total Stock", product.totalStock(), Icons.store,
                        Colors.green),
                    _card("Low Stock", product.lowStock().length, Icons.warning,
                        Colors.redAccent),
                    GestureDetector(
                      onTap: () => Get.toNamed('/products'),
                      child: _card("Manage", product.products.length,
                          Icons.list_alt, Colors.purple),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.toNamed('/sales-history'),
                        icon: const Icon(Icons.history),
                        label: const Text("Sales History"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/products'),
                  icon: const Icon(Icons.inventory_2),
                  label: const Text("Manage Products"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(String title, int value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(.9), color.withOpacity(.6)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const Spacer(),
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            value.toString(),
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
