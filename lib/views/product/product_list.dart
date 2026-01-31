import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  final ProductController product = Get.find<ProductController>();

  final search = ''.obs;
  final selectedCategory = 'All'.obs;

  final categories = ['All', 'Electronics', 'Grocery', 'Clothing', 'Other'];

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
            // 🔍 Search
            TextField(
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (v) => search.value = v,
            ),

            const SizedBox(height: 10),

            // 🏷 Category Filter
            SizedBox(
              height: 40,
              child: Obx(() => ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((c) {
                      final active = selectedCategory.value == c;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: active,
                          onSelected: (_) => selectedCategory.value = c,
                        ),
                      );
                    }).toList(),
                  )),
            ),

            const SizedBox(height: 15),

            // 📦 Product List
            Expanded(
              child: Obx(() {
                final list = product.products.where((p) {
                  final matchSearch =
                      p.name.toLowerCase().contains(search.value.toLowerCase());

                  final matchCategory = selectedCategory.value == 'All' ||
                      p.category == selectedCategory.value;

                  return matchSearch && matchCategory;
                }).toList();

                if (list.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.inventory_2, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No products found"),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final p = list[index];
                    final low = p.stock <= 5;

                    return Dismissible(
                      key: ValueKey(p.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => product.deleteProduct(p.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          onTap: () =>
                              Get.toNamed('/edit-product', arguments: p),
                          leading: CircleAvatar(
                            backgroundColor:
                                low ? Colors.redAccent : Colors.blueAccent,
                            child: Text(p.name[0].toUpperCase()),
                          ),
                          title: Text(p.name),
                          subtitle: Text("${p.category} • Stock: ${p.stock}"),
                          trailing: low
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "LOW",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : const Icon(Icons.chevron_right),
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
