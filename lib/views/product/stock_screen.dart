import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_colors.dart';

class StockScreen extends StatelessWidget {
  StockScreen({super.key});

  final product = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Total Stock")),
      body: Obx(() => GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
            itemCount: product.products.length,
            itemBuilder: (_, i) {
              final p = product.products[i];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.secondary.withOpacity(.8),
                      AppColors.secondary
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("Qty",
                        style: TextStyle(color: Colors.white.withOpacity(.7))),
                    Text("${p.stock}",
                        style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          )),
    );
  }
}
