import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/storage_service.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tile(
            Icons.delete,
            "Clear All Data",
            Colors.red,
            _clear,
          ),
          _tile(
            Icons.info,
            "About",
            Colors.blue,
            () => Get.toNamed('/about'),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData i, String t, Color c, VoidCallback f) {
    return Card(
      child: ListTile(
        onTap: f,
        leading: CircleAvatar(
          backgroundColor: c.withOpacity(.2),
          child: Icon(i, color: c),
        ),
        title: Text(t),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  void _clear() {
    Get.defaultDialog(
      title: "Confirm",
      middleText: "Delete all data?",
      confirm: ElevatedButton(
        onPressed: () async {
          await storage.clearAll();
          Get.offAllNamed('/login');
        },
        child: const Text("Yes"),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text("Cancel"),
      ),
    );
  }
}
