import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sales_controller.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_colors.dart';

class SalesScreen extends StatelessWidget {
  SalesScreen({super.key});

  final SalesController sales = Get.find<SalesController>();
  final ProductController product = Get.find<ProductController>();

  final qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Products"),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: product.products.length,
          itemBuilder: (_, i) {
            final p = product.products[i];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withOpacity(.05),
                  )
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  p.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text("Available: ${p.stock}"),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Sell"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    qty.clear();

                    Get.defaultDialog(
                      title: "Sell ${p.name}",
                      content: TextField(
                        controller: qty,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Quantity",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      confirm: ElevatedButton(
                        onPressed: () {
                          final q = int.tryParse(qty.text) ?? 0;

                          if (q <= 0) return;

                          sales.createSale(p.id, p.name, q);
                          Get.back();
                        },
                        child: const Text("Confirm"),
                      ),
                      cancel: TextButton(
                        onPressed: Get.back,
                        child: const Text("Cancel"),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
