import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart' as sizer;

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import 'detail_product_controller.dart';

class DetailProductScreen extends GetView<DetailProductController> {
  const DetailProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      double paddingAll = 20;
      double titleSize = 20;
      double sizedItem = 250;

      if (orientation == Orientation.portrait) {
        if (sizer.Device.screenType == sizer.ScreenType.mobile) {
          // mobile
          paddingAll = 20;
          titleSize = 20;
          sizedItem = 250;
        } else {
          // tablet
          paddingAll = 150;
          titleSize = 24;
          sizedItem = 250;
        }
      } else {
        // tablet or mobile
        paddingAll = 150;
        titleSize = 24;
        sizedItem = 250;
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.pressedGreen,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              AppConst.assetBackButton,
              width: 24,
              height: 24,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'detailProduct'.tr,
            style: AppStyle.bold(size: titleSize, textColor: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingAll),
            child: GetBuilder<DetailProductController>(builder: (ctrl) {
              final detailProduct = ctrl.detailProduct;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: sizedItem,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            ctrl.getCategories(detailProduct?.category ?? ''),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          detailProduct?.image ?? '',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 32),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(detailProduct?.title ?? "---",
                      style: AppStyle.bold(
                          size: 20, textColor: AppStyle.textColor)),
                  const SizedBox(height: 10),
                  Text(
                    "\$ ${detailProduct?.price ?? "---"}",
                    style: AppStyle.bold(
                        size: 20,
                        textColor:
                            ctrl.getCategories(detailProduct?.category ?? '')),
                  ),
                  Chip(
                    label: Text(detailProduct?.category ?? "Unknown",
                        style: AppStyle.regular(
                            size: 14, textColor: AppStyle.whiteColor)),
                    backgroundColor:
                        ctrl.getCategories(detailProduct?.category ?? ''),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      // ...List.generate(5, (index) {
                      //   double rate = detailProduct?.rating?.rate ?? 0;
                      //   if (index < rate.floor()) {
                      //     return const Icon(Icons.star,
                      //         color: Colors.amber, size: 30);
                      //   } else if (index < rate) {
                      //     return const Icon(Icons.star_half,
                      //         color: Colors.amber, size: 30);
                      //   } else {
                      //     return const Icon(Icons.star_border,
                      //         color: Colors.amber, size: 30);
                      //   }
                      // }),
                      RatingBarIndicator(
                        rating: detailProduct?.rating?.rate ?? 0,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 25,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "(${detailProduct?.rating?.count ?? 0} reviews)",
                        style: AppStyle.regular(
                            size: 14, textColor: AppStyle.textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "description".tr,
                    style:
                        AppStyle.bold(size: 18, textColor: AppStyle.textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detailProduct?.description ?? "---",
                    style: AppStyle.regular(
                        size: 16, textColor: AppStyle.textColor),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}
