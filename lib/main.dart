import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/sales_controller.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController(), permanent: true);
  Get.put(ProductController(), permanent: true);
  Get.put(SalesController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: AppRoutes.routes,
    );
  }
}
