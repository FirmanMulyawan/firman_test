import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notification_center/notification_center.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../component/database/database_expanse.dart';
import '../../../component/model/expense_category.dart';
import '../../../component/util/helper.dart';

class AddExpenseController extends GetxController {
  final focusNode = FocusNode();
  var isFocusedNominal = false.obs;
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController dateExpenseController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final Rx<TextEditingController> categoriController =
      TextEditingController(text: ExpenseCategory.makanan.label).obs;
  var selectedCategoryLabel = ExpenseCategory.makanan.label.obs;
  ExpenseCategory get selectedCategory => ExpenseCategory.values
      .firstWhere((e) => e.label == selectedCategoryLabel.value);
  bool isValid = false;

  // database expanse
  DatabaseManagerExpanse database = DatabaseManagerExpanse.instance;

  AddExpenseController();

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      isFocusedNominal.value = focusNode.hasFocus;
    });

    nominalController.addListener(() {
      final text = nominalController.text.replaceAll('.', '');
      if (text.isEmpty) return;

      final number = int.tryParse(text);
      if (number == null) return;

      final formatted = NumberFormat('#,###', 'id_ID').format(number);
      if (formatted != nominalController.text) {
        nominalController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  @override
  void onClose() {
    focusNode.dispose();
    nominalController.dispose();
    super.onClose();
  }

  void validate() {
    isValid = expenseController.text.isNotEmpty &&
        nominalController.text.isNotEmpty &&
        dateExpenseController.text.isNotEmpty &&
        categoriController.value.text.isNotEmpty;
    update();
  }

  void changeCategory(String category) {
    selectedCategoryLabel.value = category;
    categoriController.value.text = category;
    // Get.back();
  }

  void addExpense() async {
    final nameExpense = expenseController.text;
    final category = selectedCategory.label;
    final dateExpense = parseDate(dateExpenseController.text);
    final nominal = parseFormattedInt(nominalController.text);

    Database db = await database.db;

    await db.insert("expense", {
      "name": nameExpense,
      "category": category,
      "dateExpense": dateExpense,
      "nominal": nominal,
    });
    NotificationCenter().notify('refresh-expense');
    await AlertModel.showAlert(
        title: "Add Expense",
        message: "Berhasil menambahkan Pengeluaran",
        barrierDismissible: false,
        buttonText: "Selesai");
    Get.back(result: true);
  }

  int parseFormattedInt(String value) {
    final cleaned = value.replaceAll(RegExp(r'[.,]'), '');

    return int.tryParse(cleaned) ?? 0;
  }

  String parseDate(String dateStr) {
    final inputFormat = DateFormat("EEEE, dd MMMM yyyy", "id_ID");
    DateTime date = inputFormat.parse(dateStr);

    final outputFormat = DateFormat("yyyy-MM-dd");
    return outputFormat.format(date);
  }
}
