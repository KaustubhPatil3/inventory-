import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sales_controller.dart';
import '../../controllers/product_controller.dart';
import '../../theme/app_colors.dart';

class Sales extends StatelessWidget {
  Sales({super.key});

  final sales = Get.find<SalesController>();
  final product = Get.find<ProductController>();
  final qty = TextEditingController();
  final search = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sell Products")),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: Obx(() {
              final list = product.products
                  .where((e) =>
                      e.name.toLowerCase().contains(search.value.toLowerCase()))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final p = list[i];

                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: ListTile(
                      title: Text(p.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Stock: ${p.stock}"),
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                      ),
                      onTap: () => _sellSheet(p.id, p.name),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: (v) => search.value = v,
        decoration: InputDecoration(
          hintText: "Search product...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _sellSheet(String id, String name) {
    qty.clear();

    Get.bottomSheet(Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        TextField(
          controller: qty,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Quantity"),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final q = int.tryParse(qty.text) ?? 0;
              if (q > 0) {
                sales.createSale(id, name, q);
                Get.back();
              }
            },
            child: const Text("Confirm Sale"),
          ),
        )
      ]),
    ));
  }
}
