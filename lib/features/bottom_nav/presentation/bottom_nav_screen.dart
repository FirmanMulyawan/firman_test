import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import 'bottom_nav_controller.dart';

import 'package:sizer/sizer.dart' as sizer;

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: AppStyle.whiteColor,
          body: GetBuilder<BottomNavController>(
            builder: (ctrl) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: ctrl.selectedScreen,
                          children: ctrl.screenList,
                        ),
                      ),
                      _footerItem(context, orientation),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _footerTabletItem(context, orientation),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _footerItem(BuildContext context, Orientation orientation) {
    return Container(
      width: sizer.Device.screenType == sizer.ScreenType.mobile
          ? double.infinity
          : MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withAlpha(26),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          color: Colors.white,
          child: sizer.Device.screenType == sizer.ScreenType.mobile
              ? Column(
                  children: [
                    _bottomTabs(context),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }

  Widget _footerTabletItem(BuildContext context, Orientation orientation) {
    return Container(
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.62
          : MediaQuery.of(context).size.width / 2,
      height: sizer.Device.screenType == sizer.ScreenType.mobile ? 0 : 75,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withAlpha(26),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          color: Colors.white,
          child: sizer.Device.screenType == sizer.ScreenType.tablet
              ? Column(
                  children: [
                    _bottomTabs(context),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }

  Widget _bottomTabs(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (ctrl) {
        return Row(
          children: [
            _bottomTabItem(
              context: context,
              onTap: () {
                ctrl.setSelectedScreen(0);
              },
              icon: ctrl.selectedScreen == 0
                  ? _iconBottomTab(
                      value: AppConst.assetNavbarHomeBold,
                    )
                  : _iconBottomTab(
                      value: AppConst.assetNavbarHomeLinear,
                    ),
            ),
            _bottomTabItem(
              context: context,
              onTap: () {
                ctrl.setSelectedScreen(1);
              },
              icon: ctrl.selectedScreen == 1
                  ? _iconBottomTab(
                      value: AppConst.assetNavbarUserBold,
                    )
                  : _iconBottomTab(
                      value: AppConst.assetNavbarUserLinear,
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomTabItem({
    void Function()? onTap,
    required Widget icon,
    required BuildContext context,
  }) {
    double bottom = MediaQuery.of(context).padding.bottom;
    bottom = bottom > 0 ? bottom : 20;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: bottom),
          child: icon,
        ),
      ),
    );
  }

  Widget _iconBottomTab({
    String value = "",
  }) {
    return SvgPicture.asset(
      value,
      width: 30,
      height: 30,
    );
  }
}
