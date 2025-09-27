import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../profile/presentation/profile_screen.dart';
import '../../products/presentation/products_screen.dart';

class BottomNavController extends GetxController {
  int selectedScreen = 0;

  late List<Widget> screenList;

  @override
  void onInit() {
    screenList = [
      ProductsScreen(),
      ProfileScreen(),
    ];

    super.onInit();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  BottomNavController();

  void setSelectedScreen(int value) {
    selectedScreen = value;
    update();
  }
}
