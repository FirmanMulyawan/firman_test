import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import '../../../component/config/app_style.dart';
import '../../../component/util/helper.dart';
import '../../../component/util/state.dart';
import '../model/products_response.dart';
import '../repository/products_respository.dart';

class ProductsController extends GetxController {
  // products
  List<ProductsResponse> productsList = [];
  List<ProductsResponse> allProducts = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  final Debouncer _searchDebouncer =
      Debouncer(delay: Duration(milliseconds: 500));

  final ProductsRepository _repository;

  ProductsController(this._repository);

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void updateKeyword() {
    _searchDebouncer.call(() {
      final keyword = searchController.text.trim().toLowerCase();

      if (keyword.isEmpty) {
        productsList = List.from(allProducts);
      } else {
        productsList = allProducts.where((p) {
          final title = (p.title ?? '').toLowerCase();
          final category = (p.category ?? '').toLowerCase();

          final normalizedCategory = category.replaceAll("'", "");
          final normalizedTitle = title.replaceAll("'", "");
          final normalizedKeyword = keyword.replaceAll("'", "");

          return normalizedTitle.contains(normalizedKeyword) ||
              normalizedCategory.contains(normalizedKeyword);
        }).toList();
      }

      update();
    });
  }

  void getProducts() {
    isLoading = true;
    update();
    _repository.getListProducts(
      response: ResponseHandler(
        onSuccess: (data) async {
          allProducts.clear();
          allProducts.addAll((data.data ?? []).cast<ProductsResponse>());

          productsList.clear();
          productsList.addAll(allProducts);
        },
        onFailed: (e, message) {
          AlertModel.showAlert(title: "Error", message: message);
        },
        onDone: () {
          isLoading = false;
          update();
        },
      ),
    );
  }

  Map<String, dynamic> getCategories(String category) {
    if (category == 'men\'s clothing') {
      return {
        'color': AppStyle.homeLearnGreen,
        'shadowColor': AppStyle.homeLearnHover,
        'backgroundImage': AppStyle.pressedGreen.withValues(alpha: 0.2)
      };
    } else if (category == 'jewelery') {
      return {
        'color': AppStyle.homeAssessmentOrange,
        'shadowColor': AppStyle.homeAssessmentHover,
        'backgroundImage': AppStyle.hoverRed.withValues(alpha: 0.2)
      };
    } else if (category == 'electronics') {
      return {
        'color': AppStyle.hoverYellow,
        'shadowColor': AppStyle.homeLeaderboardHover,
        'backgroundImage': AppStyle.pressedYellow.withValues(alpha: 0.2)
      };
    } else {
      return {
        'color': AppStyle.homePrayerGreen,
        'shadowColor': AppStyle.homePrayerHover,
        'backgroundImage': AppStyle.homePrayerCircle.withValues(alpha: 0.2)
      };
    }
  }
}
