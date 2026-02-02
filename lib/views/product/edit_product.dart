import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class EditProduct extends StatelessWidget {
  EditProduct({super.key});

  final product = Get.find<ProductController>();

  final name = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();

  final selectedCategory = ''.obs;

  final categories = ["Electronics", "Grocery", "Clothing", "Other"];

  @override
  Widget build(BuildContext context) {
    final ProductModel p = Get.arguments;

    name.text = p.name;
    price.text = p.price.toString();
    stock.text = p.stock.toString();
    selectedCategory.value = p.category;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field(name, "Name", Icons.shopping_bag),
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
                onPressed: () {
                  final pr = double.tryParse(price.text) ?? 0;
                  final st = int.tryParse(stock.text) ?? 0;

                  if (pr <= 0 || st < 0) {
                    Get.snackbar("Error", "Invalid values");
                    return;
                  }

                  p.name = name.text.trim();
                  p.price = pr;
                  p.stock = st;
                  p.category = selectedCategory.value;

                  product.updateProduct(p);

                  Get.back();
                  Get.snackbar("Updated", "Product saved");
                },
                child: const Text("UPDATE"),
              ),
            )
          ],
        ),
      ),
    );
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
