import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../theme/app_colors.dart';

class LowStockScreen extends StatelessWidget {
  LowStockScreen({super.key});

  final product = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Low Stock")),
      body: Obx(() {
        final list = product.lowStock();

        if (list.isEmpty) {
          return const Center(child: Text("All products healthy 🎉"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final p = list[i];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: AppColors.danger),
                title: Text(p.name),
                subtitle: Text("Stock: ${p.stock}"),
                trailing: TextButton(
                  onPressed: () => Get.toNamed('/edit-product', arguments: p),
                  child: const Text("Restock"),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
