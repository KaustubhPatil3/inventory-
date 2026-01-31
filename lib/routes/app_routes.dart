import 'package:get/get.dart';
import '../views/auth/login.dart';
import '../views/auth/register.dart';
import '../views/auth/splash.dart';
import '../views/dashboard/home.dart';
import '../views/product/add_product.dart';
import '../views/product/product_list.dart';
import '../views/sales/sales.dart';
import '../views/settings/settings.dart';
import '../views/settings/about.dart';
import '../views/sales/sales_history.dart';
import '../views/product/edit_product.dart';
import '../views/product/low_stock.dart';
import '../views/product/stock_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/splash', page: () => Splash()),
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/register', page: () => Register()),
    GetPage(name: '/home', page: () => Home()),

    // PRODUCTS
    GetPage(name: '/add-product', page: () => AddProduct()),
    GetPage(name: '/products', page: () => ProductList()),

    GetPage(name: '/sales', page: () => Sales()),

    GetPage(name: '/settings', page: () => Settings()),
    GetPage(name: '/about', page: () => const About()),

    GetPage(name: '/splash', page: () => const Splash()),

    GetPage(name: '/sales-history', page: () => SalesHistory()),

    GetPage(name: '/edit-product', page: () => EditProduct()),

    GetPage(name: '/low-stock', page: () => LowStockScreen()),
    GetPage(name: '/stock', page: () => StockScreen()),
  ];
}
