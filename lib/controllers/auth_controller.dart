import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService storage = StorageService();

  final isLoading = false.obs;

  // ================= SNACKBAR =================

  void _showMsg(String title, String msg, {Color bg = Colors.black87}) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bg,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }

  // ================= HASH =================

  String _hash(String input) {
    return base64Encode(utf8.encode(input));
  }

  // ================= REGISTER =================

  Future<void> register(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showMsg("Error", "Fill all fields", bg: Colors.red);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showMsg("Error", "Invalid email", bg: Colors.red);
      return;
    }

    if (password.length < 6) {
      _showMsg("Error", "Min 6 chars password", bg: Colors.red);
      return;
    }

    isLoading.value = true;

    try {
      final user = UserModel(
        email: email.trim(),
        passwordHash: _hash(password),
      );

      await storage.saveUser(user);
      await storage.setLogin(true);

      _showMsg("Success", "Registered", bg: Colors.green);

      Get.offAllNamed('/home');
    } catch (e) {
      _showMsg("Error", "Register failed");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGIN =================

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showMsg("Error", "Fill all fields", bg: Colors.red);
      return;
    }

    isLoading.value = true;

    try {
      final saved = await storage.getUser();

      if (saved == null) {
        _showMsg("Error", "No user found", bg: Colors.orange);
        return;
      }

      final hash = _hash(password);

      if (saved.email == email.trim() && saved.passwordHash == hash) {
        await storage.setLogin(true);

        _showMsg("Success", "Login OK", bg: Colors.green);

        Get.offAllNamed('/home');
      } else {
        _showMsg("Error", "Wrong credentials", bg: Colors.red);
      }
    } catch (e) {
      _showMsg("Error", "Login failed");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= AUTO LOGIN =================

  Future<void> checkLogin() async {
    final logged = await storage.isLoggedIn();

    if (logged) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await storage.logout();

    _showMsg("Logout", "Done", bg: Colors.blueGrey);

    Get.offAllNamed('/login');
  }
}
