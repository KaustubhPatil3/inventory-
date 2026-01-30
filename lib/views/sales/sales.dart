import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sales_controller.dart';

class Sales extends StatelessWidget {
  Sales({super.key});

  final product = Get.find<ProductController>();
  final sales = Get.find<SalesController>();

  final qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Sale")),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: product.products.length,
          itemBuilder: (c, i) {
            final p = product.products[i];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title: Text(p.name),
                subtitle: Text("Stock: ${p.stock}"),
                trailing: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Quantity",
                      content: TextField(controller: qty),
                      confirm: ElevatedButton(
                        onPressed: () {
                          sales.createSale(p.id, p.name, int.parse(qty.text));
                          qty.clear();
                          Get.back();
                        },
                        child: const Text("Sell"),
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
