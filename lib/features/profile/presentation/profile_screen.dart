import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import '../../../component/widget/popup_button.dart';
import 'image_edit_photo.dart';
import 'profile_controller.dart';
import 'package:sizer/sizer.dart' as sizer;

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      double titleSize = 20;
      double hightGapProfile = 30;
      double paddingAll = 20;
      double imageBox = 75;
      double titleFormSize = 20;
      double descFormSize = 12;
      double prefix = 12;
      double gapDesc = 5;
      double gapForm = 15;
      double heightForm = 50;
      double textForm = 15;
      double maxHeightDropdown = 200;
      double gapChangePassword = 10;
      double gapButtonLevel = 30;
      double hightSaveButton = 50;
      double titleSaveButton = 15;

      if (orientation == Orientation.portrait) {
        if (sizer.Device.screenType == sizer.ScreenType.mobile) {
          titleSize = 20;
          hightGapProfile = 30;
          paddingAll = 20;
          imageBox = 75;
          titleFormSize = 20;
          descFormSize = 12;
          prefix = 12;
          gapDesc = 5;
          gapForm = 15;
          heightForm = 50;
          textForm = 15;
          maxHeightDropdown = 200;
          gapChangePassword = 10;
          gapButtonLevel = 30;
          hightSaveButton = 50;
          titleSaveButton = 15;
        } else {
          titleSize = 24;
          hightGapProfile = 50;
          paddingAll = 150;
          imageBox = 85;
          titleFormSize = 22;
          descFormSize = 18;
          prefix = 18;
          gapDesc = 7;
          gapForm = 20;
          heightForm = 62;
          textForm = 24;
          maxHeightDropdown = 300;
          gapChangePassword = 30;
          gapButtonLevel = 40;
          hightSaveButton = 66;
          titleSaveButton = 20;
        }
      } else {
        titleSize = 24;
        hightGapProfile = 50;
        paddingAll = 150;
        imageBox = 85;
        titleFormSize = 22;
        descFormSize = 18;
        prefix = 18;
        gapDesc = 7;
        gapForm = 20;
        heightForm = 62;
        textForm = 24;
        maxHeightDropdown = 300;
        gapChangePassword = 30;
        gapButtonLevel = 40;
        hightSaveButton = 66;
        titleSaveButton = 20;
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.pressedGreen,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'editProfile'.tr,
            style: AppStyle.bold(size: titleSize, textColor: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingAll),
            child: Column(
              children: [
                SizedBox(
                  height: hightGapProfile,
                ),
                _editProfile(imageBox: imageBox),
                SizedBox(
                  height: 30,
                ),
                _inputEditProfile(
                    titleFormSize: titleFormSize,
                    descFormSize: descFormSize,
                    prefix: prefix,
                    gapDesc: gapDesc,
                    gapForm: gapForm,
                    heightForm: heightForm,
                    textForm: textForm,
                    maxHeightDropdown: maxHeightDropdown),
                SizedBox(
                  height: gapChangePassword,
                ),
                SizedBox(
                  height: gapButtonLevel,
                ),
                _buttonSave(
                    hightSaveButton: hightSaveButton,
                    titleSaveButton: titleSaveButton),
                SizedBox(
                  height: gapButtonLevel,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buttonSave(
      {double hightSaveButton = 50, double titleSaveButton = 15}) {
    return GetBuilder<ProfileController>(builder: (ctrl) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: PopupButton(
              onPressed: ctrl.isValid
                  ? () {
                      ctrl.saveEditProfile();
                    }
                  : null,
              size: hightSaveButton,
              color: AppStyle.mainOrange,
              shadowColor: AppStyle.hoverOrange,
              child: Text(
                'saveChanges'.tr,
                textAlign: TextAlign.center,
                style: AppStyle.bold(
                  size: titleSaveButton,
                  textColor: AppStyle.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
        ],
      );
    });
  }

  Widget _inputEditProfile(
      {titleFormSize = 20,
      descFormSize = 12,
      prefix = 12,
      gapDesc = 5,
      gapForm = 15,
      heightForm = 50,
      textForm = 15,
      maxHeightDropdown = 200}) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile'.tr,
            style: AppStyle.bold(size: titleFormSize),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'name'.tr,
            style: AppStyle.regular(size: descFormSize),
          ),
          SizedBox(
            height: gapDesc,
          ),
          GetBuilder<ProfileController>(builder: (ctrl) {
            return TextFormField(
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: ctrl.nameController,
              onChanged: (string) {
                controller.validate();
              },
              decoration: InputDecoration(
                hintText: 'name'.tr,
                prefix: SizedBox(
                  width: prefix,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'emptyName'.tr;
                }
                return null;
              },
            );
          }),
          SizedBox(
            height: gapForm,
          ),
          Text(
            'phoneNumber'.tr,
            style: AppStyle.regular(size: descFormSize),
          ),
          SizedBox(
            height: gapDesc,
          ),
          SizedBox(
            height:
                sizer.Device.screenType == sizer.ScreenType.mobile ? 10 : 20,
          ),
          GetBuilder<ProfileController>(
            builder: (ctrl) {
              return TextFormField(
                keyboardType: TextInputType.phone,
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: ctrl.phoneController,
                onChanged: (string) {
                  controller.clearPhoneError();
                  controller.validate();
                },
                decoration: InputDecoration(
                  hintText: 'enterPhone'.tr,
                  errorMaxLines: 2,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          sizer.Device.screenType == sizer.ScreenType.mobile
                              ? 7
                              : 0,
                      horizontal:
                          sizer.Device.screenType == sizer.ScreenType.mobile
                              ? 10
                              : 18,
                    ),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppStyle.flagGray,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '+62',
                          style: AppStyle.regular(
                            textColor: AppStyle.pressedGreen,
                            size: textForm,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'emptyPhone'.tr;
                  }
                  if (controller.phoneErrorMessage != null) {
                    return controller.phoneErrorMessage;
                  }
                  return null;
                },
              );
            },
          ),
          SizedBox(
            height: gapForm,
          ),
          Text(
            'email'.tr,
            style: AppStyle.regular(
              size: descFormSize,
            ),
          ),
          SizedBox(
            height: gapDesc,
          ),
          GetBuilder<ProfileController>(
            builder: (ctrl) {
              return TextFormField(
                keyboardType: TextInputType.emailAddress,
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: ctrl.emailController,
                onChanged: (string) {
                  controller.clearEmailError();
                  // controller.emailController.text = string;
                  controller.validate();
                },
                decoration: InputDecoration(
                  hintText: 'enterEmail'.tr,
                  errorMaxLines: 2,
                  prefix: SizedBox(
                    width: sizer.Device.screenType == sizer.ScreenType.mobile
                        ? 12
                        : 18,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'emptyEmail'.tr;
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'validEmail'.tr;
                  }
                  if (controller.emailErrorMessage != null) {
                    return controller.emailErrorMessage;
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _editProfile({imageBox = 75}) {
    return Center(
      child: GetBuilder<ProfileController>(builder: (ctrl) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ImageEditProfile(
              imageBox: imageBox,
              imagePathProfile: ctrl.imagePathProfile ?? '',
            ),
            Positioned(
              bottom: 0,
              right: -15,
              child: GestureDetector(
                onTap: () async {
                  controller.setImageFromGallery();
                },
                child: SvgPicture.asset(
                  AppConst.assetEditPhoto,
                  width: 30,
                  height: 30,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
