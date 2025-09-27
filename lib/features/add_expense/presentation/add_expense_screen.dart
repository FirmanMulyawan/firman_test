import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import '../../../component/widget/popup_button.dart';
import 'add_expense_controller.dart';
import 'calendar_expense_popup.dart';
import 'expense_category_popup.dart';

class AddExpenseScreen extends GetView<AddExpenseController> {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.whiteColor,
        appBar: AppBar(
          backgroundColor: AppStyle.whiteColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              AppConst.iconAngleLeft,
              width: 36,
              height: 36,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Tambah Pengeluaran Baru',
            style: AppStyle.bold(size: 18),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 38,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<AddExpenseController>(builder: (ctrl) {
                        return TextFormField(
                          onTapOutside: (PointerDownEvent event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          autocorrect: false,
                          controller: ctrl.expenseController,
                          onChanged: (string) {
                            ctrl.validate();
                          },
                          decoration: InputDecoration(
                            hintText: 'Nama Pengeluaran',
                            prefix: SizedBox(
                              width: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama pengeluaran tidak boleh kosong';
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() => TextFormField(
                            readOnly: true,
                            onTapOutside: (PointerDownEvent event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: controller.categoriController.value,
                            onChanged: (string) {
                              controller.validate();
                            },
                            onTap: () async {
                              await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  clipBehavior: Clip.antiAlias,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (ctx) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ExpenseCategoryPopup(
                                        controller: controller,
                                      ),
                                    );
                                  });
                            },
                            decoration: InputDecoration(
                                hintText: 'Kategori',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    controller.selectedCategory.icon,
                                    colorFilter: ColorFilter.mode(
                                      controller.selectedCategory.color,
                                      BlendMode.srcIn,
                                    ),
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppStyle.grey5,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      AppConst.iconArrow,
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                )),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kategori tidak boleh kosong';
                              }
                              return null;
                            },
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      GetBuilder<AddExpenseController>(builder: (ctrl) {
                        return TextFormField(
                          readOnly: true,
                          onTapOutside: (PointerDownEvent event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: ctrl.dateExpenseController,
                          onChanged: (string) {
                            ctrl.validate();
                          },
                          decoration: InputDecoration(
                              hintText: 'Tanggal Pengeluaran',
                              prefix: SizedBox(
                                width: 14,
                              ),
                              // isDense: true,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  AppConst.iconCalendarAlt,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.scaleDown,
                                ),
                              )),
                          onTap: () async {
                            await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    content: Builder(builder: (ctx) {
                                      return SizedBox(
                                        width: double.maxFinite,
                                        child: CalendarExpensePopup(),
                                      );
                                    }),
                                  );
                                }).then((result) {
                              if (result != null) {
                                final DateTime onValue = result['currentDate'];

                                String formattedDate = DateFormat(
                                        'EEEE, d MMMM y',
                                        AppConst.defaultLocale)
                                    .format(onValue);

                                ctrl.dateExpenseController.text = formattedDate;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal Pengeluaran tidak boleh kosong';
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() => TextFormField(
                            focusNode: controller.focusNode,
                            onTapOutside: (PointerDownEvent event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: controller.nominalController,
                            onChanged: (string) {
                              controller.validate();
                            },
                            decoration: InputDecoration(
                              hintText: 'Nominal',
                              // prefix: SizedBox(
                              //   width: 14,
                              // ),
                              prefix: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 14),
                                  controller.isFocusedNominal.value ||
                                          controller
                                              .nominalController.text.isNotEmpty
                                      ? Text(
                                          'Rp. ',
                                          style: AppStyle.light(
                                            textColor: AppStyle.textColor,
                                            size: 14,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              // prefixText: controller.isFocusedNominal.value ||
                              //         controller
                              //             .nominalController.text.isNotEmpty
                              //     ? 'Rp. '
                              //     : null,
                              prefixStyle: AppStyle.light(
                                textColor: AppStyle.textColor,
                                size: 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nominal tidak boleh kosong';
                              }
                              return null;
                            },
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<AddExpenseController>(builder: (ctrl) {
                    return PopupButton(
                      radius: 6,
                      onPressed:
                          ctrl.isValid == true ? () => ctrl.addExpense() : null,
                      size: 50,
                      color: AppStyle.blue,
                      shadowColor: Color(0xff08788F),
                      child: Text(
                        "Simpan",
                        textAlign: TextAlign.center,
                        style: AppStyle.bold(
                          size: 18,
                          textColor: AppStyle.whiteColor,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}
