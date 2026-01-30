import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sales_controller.dart';

class SalesHistory extends StatelessWidget {
  SalesHistory({super.key});

  final sales = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales History")),
      body: Obx(() {
        if (sales.sales.isEmpty) {
          return const Center(child: Text("No sales yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: sales.sales.length,
          itemBuilder: (c, i) {
            final s = sales.sales[i];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: const Icon(Icons.point_of_sale),
                title: Text(s.productName),
                subtitle:
                    Text("Qty: ${s.quantity}\n${s.date.split('T').first}"),
              ),
            );
          },
        );
      }),
    );
  }
}
