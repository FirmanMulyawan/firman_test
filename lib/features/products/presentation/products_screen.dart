import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:sizer/sizer.dart' as sizer;
import 'package:skeletonizer/skeletonizer.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_route.dart';
import '../../../component/config/app_style.dart';
import '../../../component/widget/popup_button.dart';

import 'products_controller.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GetBuilder<ProductsController>(builder: (ctrl) {
          return Scaffold(
            body: RefreshIndicator(
              color: AppStyle.pressedGreen,
              onRefresh: () {
                controller.getProducts();
                return Future.value();
              },
              child: SizedBox(
                height: sizer.Device.screenType == sizer.ScreenType.tablet &&
                        orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height
                    : null,
                child: _topView(context, orientation),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: controller.searchController,
      autocorrect: false,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (value) {
        controller.updateKeyword();
      },
      style: AppStyle.regular(
        size: 20,
      ),
      decoration: InputDecoration(
        hintText: 'searchProduct'.tr,
        hintStyle: AppStyle.regular(
          size: 20,
          textColor: AppStyle.searchHintColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: AppStyle.searchBorderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: AppStyle.searchBorderColor,
            width: 1.5,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
            minHeight: 24, minWidth: 52, maxHeight: 24, maxWidth: 52),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 18, right: 10),
          child: SvgPicture.asset(
            AppConst.searchIcon,
            colorFilter: ColorFilter.mode(
              AppStyle.pressedGreen,
              BlendMode.srcIn,
            ),
          ),
        ),
        fillColor: AppStyle.whiteColor,
        filled: true,
      ),
    );
  }

  Widget _topView(BuildContext context, Orientation orientation) {
    List<Widget> children = [];

    if (sizer.Device.screenType == sizer.ScreenType.mobile) {
      children = [
        Positioned(
          child: SizedBox(
            height: null,
            child: SvgPicture.asset(
              AppConst.homeBanner,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: GetBuilder<ProductsController>(builder: (ctrl) {
                final productsList = ctrl.productsList;
                final isLoading = ctrl.isLoading;

                if (!isLoading && productsList.isEmpty) {
                  return Column(
                    children: [
                      _searchBar(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 60,
                              color: AppStyle.homeYoutubeRed,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'noData'.tr,
                              style: AppStyle.medium(
                                size: 35,
                                textColor: AppStyle.homeYoutubeRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    children: [
                      _searchBar(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: AlignedGridView.count(
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 22,
                            crossAxisSpacing: 25,
                            addRepaintBoundaries: false,
                            itemCount:
                                isLoading == true ? 10 : productsList.length,
                            itemBuilder: (ctx, index) {
                              return PopupButton(
                                  size: 200,
                                  color: ctrl.getCategories(isLoading == true
                                      ? 'jewelery'
                                      : productsList[index].category ??
                                          '')['color'],
                                  shadowColor: ctrl.getCategories(
                                      isLoading == true
                                          ? 'jewelery'
                                          : productsList[index].category ??
                                              '')['shadowColor'],
                                  radius: 10,
                                  width: 200,
                                  border: Border.all(
                                      color: AppStyle.whiteColor, width: 1.0),
                                  onPressed: isLoading == true
                                      ? null
                                      : () {
                                          Get.toNamed(AppRoute.detailProduct,
                                              arguments: productsList[index]);
                                        },
                                  child: _HomeButtonChild(
                                    backgroundColor: ctrl.getCategories(
                                        isLoading == true
                                            ? 'jewelery'
                                            : productsList[index].category ??
                                                '')['backgroundImage'],
                                    icon: isLoading == true
                                        ? ""
                                        : productsList[index].image ?? '',
                                    title: isLoading == true
                                        ? '---'
                                        : productsList[index].title ?? '---',
                                    price: isLoading == true
                                        ? '---'
                                        : (productsList[index].price != null
                                            ? productsList[index]
                                                .price
                                                .toString()
                                            : '---'),
                                    // category: isLoading == true
                                    //     ? '---'
                                    //     : productsList[index].category ?? '---',
                                    // count: isLoading == true
                                    //     ? '---'
                                    //     : (productsList[index].rating!.count != null
                                    //         ? "(${productsList[index].rating!.count.toString()} views)"
                                    //         : '---'),
                                    // rate: isLoading == true
                                    //     ? 5.0
                                    //     : (productsList[index].rating!.rate != null
                                    //         ? productsList[index]
                                    //             .rating!
                                    //             .rate!
                                    //             .toDouble()
                                    //         : 0.0),
                                  ));
                            }),
                      ),
                    ],
                  ),
                );
              }),
            ))
      ];
    } else {
      children = [
        SvgPicture.asset(
          orientation == Orientation.portrait
              ? AppConst.homeBannerTablet
              : AppConst.homeBannerLandscape,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 20,
              ),
              child: GetBuilder<ProductsController>(builder: (ctrl) {
                final productsList = ctrl.productsList;
                final isLoading = ctrl.isLoading;

                if (!isLoading && productsList.isEmpty) {
                  return Column(
                    children: [
                      _searchBar(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 60,
                              color: AppStyle.homeYoutubeRed,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'noData'.tr,
                              style: AppStyle.medium(
                                size: 35,
                                textColor: AppStyle.homeYoutubeRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    children: [
                      _searchBar(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: AlignedGridView.count(
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 22,
                            crossAxisSpacing: 25,
                            addRepaintBoundaries: false,
                            itemCount:
                                isLoading == true ? 10 : productsList.length,
                            itemBuilder: (ctx, index) {
                              return PopupButton(
                                  size: 250,
                                  color: ctrl.getCategories(isLoading == true
                                      ? 'jewelery'
                                      : productsList[index].category ??
                                          '')['color'],
                                  shadowColor: ctrl.getCategories(
                                      isLoading == true
                                          ? 'jewelery'
                                          : productsList[index].category ??
                                              '')['shadowColor'],
                                  radius: 10,
                                  width: 250,
                                  border: Border.all(
                                      color: AppStyle.whiteColor, width: 1.0),
                                  onPressed: isLoading == true
                                      ? null
                                      : () {
                                          Get.toNamed(AppRoute.detailProduct,
                                              arguments: productsList[index]);
                                        },
                                  child: _HomeButtonChild(
                                    backgroundColor: ctrl.getCategories(
                                        isLoading == true
                                            ? 'jewelery'
                                            : productsList[index].category ??
                                                '')['backgroundImage'],
                                    icon: isLoading == true
                                        ? ""
                                        : productsList[index].image ?? '',
                                    title: isLoading == true
                                        ? '---'
                                        : productsList[index].title ?? '---',
                                    price: isLoading == true
                                        ? '---'
                                        : (productsList[index].price != null
                                            ? productsList[index]
                                                .price
                                                .toString()
                                            : '---'),
                                    // category: isLoading == true
                                    //     ? '---'
                                    //     : productsList[index].category ?? '---',
                                    // count: isLoading == true
                                    //     ? '---'
                                    //     : (productsList[index].rating!.count != null
                                    //         ? "(${productsList[index].rating!.count.toString()} views)"
                                    //         : '---'),
                                    // rate: isLoading == true
                                    //     ? 5.0
                                    //     : (productsList[index].rating!.rate != null
                                    //         ? productsList[index]
                                    //             .rating!
                                    //             .rate!
                                    //             .toDouble()
                                    //         : 0.0),
                                  ));
                            }),
                      ),
                    ],
                  ),
                );
              }),
            ))
      ];
    }

    return Stack(
      children: children,
    );
  }
}

class _HomeButtonChild extends StatelessWidget {
  const _HomeButtonChild({
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.price,
    // required this.category,
    // required this.count,
    // required this.rate,
  });

  final Color backgroundColor;
  final String title;
  final String icon;
  final String price;
  // final String category;
  // final String count;
  // final double rate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width:
                sizer.Device.screenType == sizer.ScreenType.tablet ? 120 : 90,
            height:
                sizer.Device.screenType == sizer.ScreenType.tablet ? 120 : 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: backgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                icon,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image));
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppStyle.medium(
            size: sizer.Device.screenType == sizer.ScreenType.tablet ? 20 : 14,
            textColor: AppStyle.whiteColor,
          ),
        ),
        Spacer(),
        Text(
          "\$ $price",
          style: AppStyle.bold(
            size: sizer.Device.screenType == sizer.ScreenType.tablet ? 25 : 16,
            textColor: AppStyle.whiteColor,
          ),
        ),
        // const SizedBox(height: 4),
        // Text(
        //   category,
        //   style: AppStyle.regular(
        //     size: 12,
        //     textColor: AppStyle.whiteColor,
        //   ),
        // ),
        // const SizedBox(height: 6),
        // Row(
        //   children: [
        //     ...List.generate(5, (index) {
        //       double rate = 3.9;
        //       if (index < rate.floor()) {
        //         return const Icon(Icons.star, color: Colors.white, size: 18);
        //       } else if (index < rate) {
        //         return const Icon(Icons.star_half,
        //             color: Colors.white, size: 18);
        //       } else {
        //         return const Icon(Icons.star_border,
        //             color: Colors.white, size: 18);
        //       }
        //     }),
        //   ],
        // ),
        // RatingBarIndicator(
        //   rating: rate,
        //   itemBuilder: (context, index) => const Icon(
        //     Icons.star,
        //     color: Colors.white,
        //   ),
        //   itemCount: 5,
        //   itemSize: 18,
        //   direction: Axis.horizontal,
        // ),
        // Text(
        //   count,
        //   style: AppStyle.regular(
        //     size: 12,
        //     textColor: AppStyle.whiteColor,
        //   ),
        // ),
      ],
    );
  }
}
