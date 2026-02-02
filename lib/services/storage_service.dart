import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/sale_model.dart';

class StorageService {
  static const userKey = "user";
  static const loginKey = "loggedIn";
  static const productKey = "products";
  static const salesKey = "sales";

  // ================= USER =================

  Future<void> saveUser(UserModel user) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(userKey);

    if (data == null) return null;

    return UserModel.fromJson(jsonDecode(data));
  }

  // ================= LOGIN =================

  Future<void> setLogin(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(loginKey, value);
  }

  Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(loginKey) ?? false;
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(loginKey, false);
  }

  // ================= PRODUCTS =================

  Future<void> saveProducts(List<ProductModel> products) async {
    final pref = await SharedPreferences.getInstance();

    final data = products.map((e) => e.toJson()).toList();

    await pref.setString(productKey, jsonEncode(data));
  }

  Future<List<ProductModel>> getProducts() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(productKey);

    if (data == null) return [];

    final list = jsonDecode(data) as List;

    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  // ================= SALES =================

  Future<void> saveSales(List<SaleModel> sales) async {
    final pref = await SharedPreferences.getInstance();

    final data = sales.map((e) => e.toJson()).toList();

    await pref.setString(salesKey, jsonEncode(data));
  }

  Future<List<SaleModel>> getSales() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(salesKey);

    if (data == null) return [];

    final list = jsonDecode(data) as List;

    return list.map((e) => SaleModel.fromJson(e)).toList();
  }

  // ================= CLEAR =================

  Future<void> clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  // ================= SETTINGS =================

  Future<void> saveSettings(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('settings', jsonEncode(data));
  }

  Future<Map<String, dynamic>> getSettings() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('settings');

    if (data == null) return {};

    return Map<String, dynamic>.from(jsonDecode(data));
  }
}
