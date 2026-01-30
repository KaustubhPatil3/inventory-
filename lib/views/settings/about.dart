import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.inventory_2, size: 80),
              SizedBox(height: 20),
              Text(
                "Inventory Management System",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Flutter + GetX + SharedPreferences"),
              SizedBox(height: 6),
              Text("Mini Project"),
            ],
          ),
        ),
      ),
    );
  }
}
