import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class AddProduct extends StatelessWidget {
  AddProduct({super.key});

  final name = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();

  final selectedCategory = 'Electronics'.obs;

  final categories = ["Electronics", "Grocery", "Clothing", "Other"];

  final product = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field(name, "Product Name", Icons.shopping_bag),
            const SizedBox(height: 15),
            Obx(() => DropdownButtonFormField(
                  value: selectedCategory.value,
                  items: categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => selectedCategory.value = v!,
                  decoration: const InputDecoration(labelText: "Category"),
                )),
            const SizedBox(height: 15),
            _field(price, "Price", Icons.currency_rupee,
                type: TextInputType.number),
            const SizedBox(height: 15),
            _field(stock, "Stock", Icons.inventory, type: TextInputType.number),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("SAVE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _save() {
    if (name.text.isEmpty || price.text.isEmpty || stock.text.isEmpty) {
      Get.snackbar("Error", "Fill all fields");
      return;
    }

    final s = int.tryParse(stock.text) ?? 0;
    final p = double.tryParse(price.text) ?? 0;

    if (s <= 0 || p <= 0) {
      Get.snackbar("Error", "Invalid values");
      return;
    }

    final productName = name.text.trim().toUpperCase();

    final existing = product.products
        .firstWhereOrNull((e) => e.name.toUpperCase() == productName);

    if (existing != null) {
      existing.stock += s;
      existing.price = p;

      product.updateProduct(existing);

      Get.back();
      Get.snackbar("Updated", "Stock increased");
    } else {
      final model = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: productName,
        category: selectedCategory.value,
        price: p,
        stock: s,
        createdAt: DateTime.now().toString(),
      );

      product.addProduct(model);

      Get.back();
      Get.snackbar("Success", "Product added");
    }
  }

  Widget _field(TextEditingController c, String l, IconData i,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: l,
        prefixIcon: Icon(i),
      ),
    );
  }
}
