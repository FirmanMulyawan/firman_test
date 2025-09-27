import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import '../../../component/model/expense_category.dart';
import 'home_controller.dart';
import 'widget/expense_category_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Halo, User!",
                  style: AppStyle.bold(size: 18),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Jangan lupa catat keuanganmu setiap hari!",
                  style: AppStyle.regular(textColor: AppStyle.grey3),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    _cardExpenseTonday(),
                    SizedBox(
                      width: 19,
                    ),
                    _cardExpenseMonth(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Pengeluaran berdasarkan kategori",
                  style: AppStyle.bold(),
                ),
                _expenseCategory(),
                SizedBox(
                  height: 8,
                ),
                _dailyExpenseList(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.toAddExpense(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppStyle.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppConst.iconUilPlus,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardExpenseTonday() {
    return Expanded(
      child: GetBuilder<HomeController>(builder: (ctrl) {
        return FutureBuilder<int>(
            future: ctrl.getExpenseToday(),
            builder: (context, snapshort) {
              if (snapshort.connectionState == ConnectionState.waiting) {
                return _cardExpense(
                    title: 'Pengeluaranmu\nhari ini', nominal: "30.000");
              }

              if (snapshort.data == 0) {
                return _cardExpense(
                    title: 'Pengeluaranmu\nhari ini', nominal: "Rp. 0");
              }

              final data = snapshort.data as int;
              return _cardExpense(
                  title: 'Pengeluaranmu\nhari ini',
                  nominal: formatRupiah(data));
            });
      }),
    );
  }

  Widget _cardExpenseMonth() {
    return Expanded(
      child: GetBuilder<HomeController>(builder: (ctrl) {
        return FutureBuilder<int>(
            future: ctrl.getExpenseMonth(),
            builder: (context, snapshort) {
              if (snapshort.connectionState == ConnectionState.waiting) {
                return _cardExpense(
                    color: AppStyle.teal,
                    title: 'Pengeluaranmu\nbulan ini',
                    nominal: "Rp. 335.500");
              }

              if (snapshort.data == 0) {
                return _cardExpense(
                    color: AppStyle.teal,
                    title: 'Pengeluaranmu\nbulan ini',
                    nominal: "Rp. 0");
              }
              final data = snapshort.data as int;

              return _cardExpense(
                  color: AppStyle.teal,
                  title: 'Pengeluaranmu\nbulan ini',
                  nominal: formatRupiah(data));
            });
      }),
    );
  }

  Widget _dailyExpenseList() {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: ctrl.getExpenseDaily(),
          builder: (context, snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hari ini",
                      style: AppStyle.bold(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _dailyExpenseCards(
                        colorIcon: AppStyle.blue,
                        iconName: AppConst.iconBasketball,
                        title: 'Ayam Geprek',
                        price: 'Rp. 15.000'),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      "Kemarin",
                      style: AppStyle.bold(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _dailyExpenseCards(
                        colorIcon: AppStyle.blue,
                        iconName: AppConst.iconBasketball,
                        title: 'Ayam Geprek',
                        price: 'Rp. 15.000'),
                  ],
                ),
              );
            }

            if (snapshort.data?.isEmpty == true) {
              return Center(
                child: Text("Data Pengeluaran Belum Ada"),
              );
            }

            final data =
                snapshort.data as Map<String, List<Map<String, dynamic>>>;
            return Column(
                children: data.entries.map(
              (entry) {
                final date = entry.key;
                final expenses = entry.value;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDateLabel(date),
                      style: AppStyle.bold(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: expenses.map((value) {
                        return Column(
                          children: [
                            _dailyExpenseCards(
                                colorIcon: ExpenseCategoryExtension.fromLabel(
                                        value['category'])
                                    .color,
                                iconName: ExpenseCategoryExtension.fromLabel(
                                        value['category'])
                                    .icon,
                                title: value['name'],
                                price: formatRupiah(value['nominal'])),
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    )
                  ],
                );
              },
            ).toList());
          });
    });
  }

  Widget _expenseCategory() {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: ctrl.getExpenseCategory(),
          builder: (context, snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return Skeletonizer(
                enabled: true,
                child: ExpenseCategoryCard(
                  backgroundColorIcon: AppStyle.yellow,
                  iconCard: AppConst.iconBasketball,
                  title: "Internet",
                  totalAmount: "Rp. 20.000",
                ),
              );
            }

            if (snapshort.data?.isEmpty == true) {
              return Center(
                child: Text("Data Pengeluaran berdasarkan kategori Belum Ada"),
              );
            }

            final data = snapshort.data as List<Map<String, dynamic>>;

            return SizedBox(
              height: 180,
              child: AlignedGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  scrollDirection: Axis.horizontal,
                  addRepaintBoundaries: false,
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: ExpenseCategoryCard(
                        backgroundColorIcon: ExpenseCategoryExtension.fromLabel(
                                data[index]['category'])
                            .color,
                        iconCard: ExpenseCategoryExtension.fromLabel(
                                data[index]['category'])
                            .icon,
                        title: ExpenseCategoryExtension.fromLabel(
                                data[index]['category'])
                            .label,
                        totalAmount: formatRupiah(data[index]["total"]),
                      ),
                    );
                  }),
            );
          });
    });
  }

  // === reusable widget
  Widget _cardExpense({Color? color, String title = '', String nominal = ''}) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? AppStyle.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyle.medium(textColor: AppStyle.whiteColor),
          ),
          SizedBox(
            height: 15,
          ),
          Text(nominal,
              style: AppStyle.bold(textColor: AppStyle.whiteColor, size: 18))
        ],
      ),
    );
  }

  Widget _dailyExpenseCards(
      {String? iconName,
      Color? colorIcon,
      String title = '',
      String price = ''}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 22),
      decoration: BoxDecoration(
        color: AppStyle.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Center(
            child: SvgPicture.asset(
              iconName ?? '',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                colorIcon ?? AppStyle.yellow,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Text(
              title,
              style: AppStyle.regular(),
            ),
          ),
          Text(
            price,
            style: AppStyle.medium(),
          ),
        ],
      ),
    );
  }

  // === helper
  String formatRupiah(int number) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  String formatDateLabel(String dateString) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final parsed = DateTime.parse(dateString);
    final target = DateTime(parsed.year, parsed.month, parsed.day);

    final diff = target.difference(today).inDays;

    if (diff == 0) {
      return "Hari ini";
    } else if (diff == -1) {
      return "Kemarin";
    } else {
      return DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(parsed);
    }
  }
}
