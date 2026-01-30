import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/sales_controller.dart';

class SalesChart extends StatelessWidget {
  SalesChart({super.key});

  final sales = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales Chart")),
      body: Obx(() {
        final data = sales.sales;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: BarChart(
            BarChartData(
              barGroups: List.generate(
                data.length,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(toY: data[i].quantity.toDouble()),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
