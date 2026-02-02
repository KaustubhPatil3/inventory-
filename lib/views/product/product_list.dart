import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  final product = Get.find<ProductController>();

  final search = ''.obs;
  final sort = 'Name'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/add-product'),
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
      body: Column(
        children: [
          _searchBar(),
          _sortBar(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Search...",
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (v) => search.value = v,
      ),
    );
  }

  Widget _sortBar() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text("Sort: "),
              DropdownButton<String>(
                value: sort.value,
                items: ["Name", "Price", "Stock"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => sort.value = v!,
              )
            ],
          ),
        ));
  }

  Widget _list() {
    return Obx(() {
      var list = product.products.where((p) {
        return p.name.toLowerCase().contains(search.value.toLowerCase());
      }).toList();

      if (sort.value == 'Price') {
        list.sort((a, b) => a.price.compareTo(b.price));
      } else if (sort.value == 'Stock') {
        list.sort((a, b) => a.stock.compareTo(b.stock));
      } else {
        list.sort((a, b) => a.name.compareTo(b.name));
      }

      if (list.isEmpty) {
        return const Center(child: Text("No Products"));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final p = list[i];

          return Dismissible(
            key: ValueKey(p.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              final temp = p;

              product.deleteProduct(p.id);

              Get.snackbar(
                "Deleted",
                p.name,
                mainButton: TextButton(
                  onPressed: () => product.addProduct(temp),
                  child: const Text("UNDO"),
                ),
              );
            },
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              child: ListTile(
                onTap: () => Get.toNamed('/edit-product', arguments: p),
                title: Text(p.name),
                subtitle: Text("${p.category} • ${p.stock} pcs"),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      );
    });
  }
}
