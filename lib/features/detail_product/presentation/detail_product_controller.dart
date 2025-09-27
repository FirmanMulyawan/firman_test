import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/config/app_style.dart';
import '../../products/model/products_response.dart';

class DetailProductController extends GetxController {
  ProductsResponse? detailProduct;

  DetailProductController();

  @override
  void onInit() {
    detailProduct = Get.arguments as ProductsResponse?;
    super.onInit();
  }

  Color getCategories(String category) {
    if (category == 'men\'s clothing') {
      return AppStyle.homeLearnGreen;
    } else if (category == 'jewelery') {
      return AppStyle.homeAssessmentOrange;
    } else if (category == 'electronics') {
      return AppStyle.hoverYellow;
    } else {
      return AppStyle.homePrayerGreen;
    }
  }
}
