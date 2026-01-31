import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class EditProduct extends StatelessWidget {
  EditProduct({super.key});

  final ProductController product = Get.find<ProductController>();

  final name = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();

  final categories = ["Electronics", "Grocery", "Clothing", "Other"];
  final selectedCategory = "".obs;

  @override
  Widget build(BuildContext context) {
    final ProductModel p = Get.arguments;

    name.text = p.name;
    price.text = p.price.toString();
    stock.text = p.stock.toString();
    selectedCategory.value = p.category;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field(name, "Product Name", Icons.shopping_bag),
            const SizedBox(height: 15),
            Obx(
              () => DropdownButtonFormField(
                initialValue: selectedCategory.value,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => selectedCategory.value = v!,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
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
                  p.name = name.text.trim();
                  p.category = selectedCategory.value;
                  p.price = double.parse(price.text);
                  p.stock = int.parse(stock.text);

                  product.updateProduct(p);

                  Get.back();
                  Get.snackbar("Updated", "Product updated",
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: const Text("UPDATE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
