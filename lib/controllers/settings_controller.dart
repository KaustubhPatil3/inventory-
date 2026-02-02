import 'package:get/get.dart';

import '../services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService storage = StorageService();

  final isDarkMode = false.obs;
  final notifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final data = await storage.getSettings();

    isDarkMode.value = data['dark'] ?? false;
    notifications.value = data['notify'] ?? true;
  }

  Future<void> toggleTheme(bool v) async {
    isDarkMode.value = v;
    await _save();
  }

  Future<void> toggleNotify(bool v) async {
    notifications.value = v;
    await _save();
  }

  Future<void> _save() async {
    await storage.saveSettings({
      'dark': isDarkMode.value,
      'notify': notifications.value,
    });
  }

  Future<void> reset() async {
    await storage.clearAll();
    Get.offAllNamed('/login');
  }
}
