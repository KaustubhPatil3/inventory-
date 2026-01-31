import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sales_controller.dart';
import '../../theme/app_colors.dart';

class SalesHistory extends StatelessWidget {
  SalesHistory({super.key});

  final SalesController sales = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Get.defaultDialog(
                title: "Clear Sales?",
                middleText: "This cannot be undone",
                confirm: ElevatedButton(
                  onPressed: () {
                    sales.clearSales();
                    Get.back();
                  },
                  child: const Text("Clear"),
                ),
                cancel: TextButton(
                  onPressed: Get.back,
                  child: const Text("Cancel"),
                ),
              );
            },
          )
        ],
      ),
      body: Obx(() {
        if (sales.sales.isEmpty) {
          return const Center(child: Text("No sales yet"));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _stat("Today", sales.todaySalesCount()),
                  const SizedBox(width: 10),
                  _stat("Total", sales.sales.length),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sales.sales.length,
                itemBuilder: (_, i) {
                  final s = sales.sales[i];

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      leading: const Icon(Icons.point_of_sale),
                      title: Text(s.productName),
                      subtitle: Text(
                        "Qty: ${s.quantity}\n${s.date.split('T').first}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _stat(String t, int v) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(t),
            const SizedBox(height: 4),
            Text(
              v.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
