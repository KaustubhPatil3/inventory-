import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _tile(
              icon: Icons.delete_forever,
              title: "Clear All Data",
              color: Colors.redAccent,
              onTap: () {
                Get.defaultDialog(
                  title: "Confirm",
                  middleText: "Delete everything?",
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
              },
            ),
            const SizedBox(height: 20),
            _tile(
              icon: Icons.info_outline,
              title: "About",
              color: Colors.blue,
              onTap: () => Get.toNamed('/about'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
