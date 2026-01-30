import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService storage = StorageService();

  void showMsg(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
    );
  }

  Future<void> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showMsg("Error", "Please fill all fields");
      return;
    }

    final user = UserModel(email: email, password: password);

    await storage.saveUser(user);
    await storage.setLogin(true);

    showMsg("Success", "Registration Successful");

    Get.offAllNamed('/home');
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showMsg("Error", "Please fill all fields");
      return;
    }

    final savedUser = await storage.getUser();

    if (savedUser == null) {
      showMsg("Failed", "No user found. Please register.");
      return;
    }

    if (savedUser.email == email && savedUser.password == password) {
      await storage.setLogin(true);

      showMsg("Success", "Login Successful");

      Get.offAllNamed('/home');
    } else {
      showMsg("Failed", "Invalid email or password");
    }
  }

  Future<void> checkLogin() async {
    final logged = await storage.isLoggedIn();

    if (logged) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> logout() async {
    await storage.logout();
    showMsg("Logout", "Logged out successfully");
    Get.offAllNamed('/login');
  }
}
