import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../theme/app_colors.dart';

class StockScreen extends StatelessWidget {
  StockScreen({super.key});

  final product = Get.find<ProductController>();
  final sales = Get.find<SalesController>();

  final search = ''.obs;
  final qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Stock")),
      body: Column(
        children: [
          _summary(),
          _searchBar(),
          Expanded(child: _grid()),
        ],
      ),
    );
  }

  // ================= SUMMARY =================

  Widget _summary() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Stock",
                    style: TextStyle(color: Colors.white70)),
                Text(
                  product.totalStock().toString(),
                  style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }

  // ================= SEARCH =================

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Search product...",
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (v) => search.value = v,
      ),
    );
  }

  // ================= GRID =================

  Widget _grid() {
    return Obx(() {
      final list = product.products
          .where(
              (e) => e.name.toLowerCase().contains(search.value.toLowerCase()))
          .toList();

      if (list.isEmpty) {
        return const Center(child: Text("No products"));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final p = list[i];
          final low = p.stock <= 5;

          return GestureDetector(
            onLongPress: () => _quickSell(p.id, p.name),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: low
                      ? [AppColors.danger, AppColors.danger]
                      : [
                          AppColors.secondary.withOpacity(.8),
                          AppColors.secondary,
                        ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory, color: Colors.white),
                      const Spacer(),
                      if (low) const Icon(Icons.warning, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text("₹${p.price}",
                      style: const TextStyle(color: Colors.white70)),
                  Text(
                    "${p.stock}",
                    style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // ================= QUICK SELL =================

  void _quickSell(String id, String name) {
    qty.clear();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              child: const Text("Quick Sell"),
            ),
          )
        ]),
      ),
    );
  }
}
