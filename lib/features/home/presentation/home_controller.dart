import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:notification_center/notification_center.dart';
import 'package:sqflite/sqflite.dart';

import '../../../component/config/app_route.dart';
import '../../../component/database/database.dart';

class HomeController extends GetxController {
  // database expanse
  DatabaseManager database = DatabaseManager.instance;

  HomeController();

  @override
  void onInit() {
    NotificationCenter().subscribe('refresh-expense', (_) {
      getExpenseDaily();
      getExpenseCategory();
      getExpenseToday();
      getExpenseMonth();
      update();
    });
    super.onInit();
  }

  @override
  void onClose() {
    NotificationCenter().unsubscribe('refresh-expense');
    super.onClose();
  }

  void toAddExpense() {
    Get.toNamed(AppRoute.addExpense);
    // final data = await Get.toNamed(AppRoute.addExpense);
    // if (data == true) {
    //   getExpenseDaily();
    //   getExpenseCategory();
    //   getExpenseToday();
    //   getExpenseMonth();
    //   update();
    // }
  }

  Future<Map<String, List<Map<String, dynamic>>>> getExpenseDaily() async {
    Database db = await database.db;
    List<Map<String, dynamic>> getExpenseDaily = await db.query(
      "expense",
      orderBy: "dateExpense ASC",
    );
    // List<Map<String, dynamic>> getExpenseDaily = await db.rawQuery('''
    //   SELECT * FROM expense
    //   ORDER BY dateExpense ASC
    // ''');
    // Grouping
    final grouped = groupBy<Map<String, dynamic>, String>(
        getExpenseDaily, (row) => row["dateExpense"].toString());

    return grouped;
  }

  Future<List<Map<String, dynamic>>> getExpenseCategory() async {
    Database db = await database.db;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT category, SUM(nominal) as total
      FROM expense
      GROUP BY category
    ''');

    return result;
  }

  Future<int> getExpenseToday() async {
    Database db = await database.db;
    DateTime today = DateTime.now();
    String todayStr = today.toIso8601String().substring(0, 10);

    // List<Map<String, dynamic>> getExpenseDaily = await db.query(
    //   "expense",
    //   orderBy: "dateExpense DESC",
    // );

    // int totalToday = getExpenseDaily
    //     .where((e) => e['dateExpense'] == todayStr)
    //     .fold(0, (sum, e) => sum + (e['nominal'] as int));
    // return totalToday;

    final result = await db.rawQuery('''
      SELECT SUM(nominal) as total
      FROM expense
      WHERE dateExpense = ?
    ''', [todayStr]);

    int totalToday = result.first['total'] as int? ?? 0;
    return totalToday;
  }

  Future<int> getExpenseMonth() async {
    Database db = await database.db;
    DateTime today = DateTime.now();

    String monthNow = "${today.year}-${today.month.toString().padLeft(2, '0')}";

    final result = await db.rawQuery('''
      SELECT SUM(nominal) as total
      FROM expense
      WHERE strftime('%Y-%m', dateExpense) = ?
    ''', [monthNow]);

    int totalMonth = result.first['total'] as int? ?? 0;
    return totalMonth;
  }
}
