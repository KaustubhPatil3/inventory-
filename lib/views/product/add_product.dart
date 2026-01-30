import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class AddProduct extends StatelessWidget {
  AddProduct({super.key});

  final name = TextEditingController();
  final category = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();

  final ProductController product = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 12,
                  )
                ],
              ),
              child: Column(
                children: [
                  _field(
                    controller: name,
                    label: "Product Name",
                    icon: Icons.shopping_bag,
                  ),
                  const SizedBox(height: 15),
                  _field(
                    controller: category,
                    label: "Category",
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 15),
                  _field(
                    controller: price,
                    label: "Price",
                    icon: Icons.currency_rupee,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _field(
                    controller: stock,
                    label: "Stock Quantity",
                    icon: Icons.inventory,
                    keyboard: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    if (name.text.isEmpty ||
                        category.text.isEmpty ||
                        price.text.isEmpty ||
                        stock.text.isEmpty) {
                      Get.snackbar("Error", "Fill all fields",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    final p = ProductModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name.text.trim(),
                      category: category.text.trim(),
                      price: double.parse(price.text),
                      stock: int.parse(stock.text),
                      createdAt: DateTime.now().toString(),
                    );

                    product.addProduct(p);
                    Get.back();

                    Get.snackbar("Success", "Product added",
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  child: const Text(
                    "SAVE PRODUCT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
