import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:purchase/main_page.dart';
import 'package:purchase/purchase.dart';

List<GetPage<dynamic>> appRoutes = [
  GetPage(
    name: '/main',
    page: () => MainPage(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    if (kDebugMode) {
      print(page?.name);
    }
    return super.onPageCalled(page);
  }
}