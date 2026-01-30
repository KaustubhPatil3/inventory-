import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  final ProductController product = Get.find<ProductController>();
  final search = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/add-product'),
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (v) => search.value = v,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                final list = product.products
                    .where((p) => p.name
                        .toLowerCase()
                        .contains(search.value.toLowerCase()))
                    .toList();

                if (list.isEmpty) {
                  return const Center(child: Text("No products"));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final p = list[index];
                    final low = p.stock <= 5;

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: low ? Colors.red : Colors.blueAccent,
                          child: Text(p.name[0].toUpperCase()),
                        ),
                        title: Text(p.name),
                        subtitle: Text("${p.category} • Stock: ${p.stock}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => product.deleteProduct(p.id),
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
