import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import '../../../component/model/expense_category.dart';
import 'add_expense_controller.dart';

class ExpenseCategoryPopup extends StatefulWidget {
  final AddExpenseController? controller;

  const ExpenseCategoryPopup({super.key, this.controller});

  @override
  State<ExpenseCategoryPopup> createState() => _ExpenseCategoryPopupState();
}

class _ExpenseCategoryPopupState extends State<ExpenseCategoryPopup> {
  late AddExpenseController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        margin: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.only(top: 24, left: 28, right: 28, bottom: 64),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pilih Kategori",
                          // font => Open Sans
                          style: AppStyle.medium(textColor: AppStyle.grey1),
                        ),
                      ),
                      Positioned(
                        right: -8,
                        top: 0,
                        bottom: 0,
                        child: Material(
                          shape: CircleBorder(),
                          child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: () => Get.back(),
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    AppConst.iconMultiply,
                                    width: 18,
                                    height: 18,
                                  ))),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 27,
                ),
                AlignedGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 23,
                    addRepaintBoundaries: false,
                    itemCount: ExpenseCategory.values.length,
                    itemBuilder: (ctx, index) {
                      final category = ExpenseCategory.values[index];

                      return Obx(() {
                        final isSelected =
                            _controller?.selectedCategory.label ==
                                category.label;

                        return GestureDetector(
                          onTap: () =>
                              _controller?.changeCategory(category.label),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppStyle.blue
                                    : Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: category.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      category.icon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  category.label,
                                  style: AppStyle.light(
                                    size: 12,
                                    textColor: isSelected
                                        ? AppStyle.blue
                                        : AppStyle.grey3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
