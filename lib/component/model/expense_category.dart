import 'package:flutter/material.dart';

import '../config/app_const.dart';
import '../config/app_style.dart';

enum ExpenseCategory {
  makanan("Makanan"),
  internet("Internet"),
  edukasi("Edukasi"),
  hadiah("Hadiah"),
  transport("Transport"),
  belanja("Belanja"),
  alatRumah("Alat Rumah"),
  olahraga("Olahraga"),
  hiburan("Hiburan");

  final String label;

  const ExpenseCategory(this.label);

  Color get color {
    switch (this) {
      case ExpenseCategory.makanan:
        return AppStyle.yellow;
      case ExpenseCategory.internet:
        return AppStyle.blue3;
      case ExpenseCategory.edukasi:
        return AppStyle.orange;
      case ExpenseCategory.hadiah:
        return AppStyle.red;
      case ExpenseCategory.transport:
        return AppStyle.purple1;
      case ExpenseCategory.belanja:
        return AppStyle.green2;
      case ExpenseCategory.alatRumah:
        return AppStyle.purple2;
      case ExpenseCategory.olahraga:
        return AppStyle.blue2;
      case ExpenseCategory.hiburan:
        return AppStyle.blue1;
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.makanan:
        return AppConst.iconPizzaSlice;
      case ExpenseCategory.internet:
        return AppConst.iconRssAlt;
      case ExpenseCategory.edukasi:
        return AppConst.iconBookOpen;
      case ExpenseCategory.hadiah:
        return AppConst.iconGift;
      case ExpenseCategory.transport:
        return AppConst.iconCarSideview;
      case ExpenseCategory.belanja:
        return AppConst.iconShoppingCart;
      case ExpenseCategory.alatRumah:
        return AppConst.iconHome;
      case ExpenseCategory.olahraga:
        return AppConst.iconBasketball;
      case ExpenseCategory.hiburan:
        return AppConst.iconClapperBoard;
    }
  }
}

extension ExpenseCategoryExtension on ExpenseCategory {
  static ExpenseCategory fromLabel(String label) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.label == label,
      orElse: () => ExpenseCategory.makanan,
    );
  }
}
