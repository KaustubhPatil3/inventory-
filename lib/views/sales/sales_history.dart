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
          return const Center(
            child: Text("No sales yet"),
          );
        }

        return Column(
          children: [
            // ================= STATS =================

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

            // ================= LIST =================

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sales.sales.length,
                itemBuilder: (_, i) {
                  final s = sales.sales[i];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.point_of_sale),
                      title: Text(
                        s.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "Qty: ${s.quantity}\n${_formatDate(s.date)}",
                      ),
                      trailing: Text(
                        "₹${(s.price * s.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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

  // ================= DATE FORMAT =================

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/"
        "${d.month.toString().padLeft(2, '0')}/"
        "${d.year}";
  }

  // ================= STAT CARD =================

  Widget _stat(String t, int v) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              t,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
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
