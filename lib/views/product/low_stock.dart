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

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.danger),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(p.name,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("${p.stock}",
                        style: const TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
