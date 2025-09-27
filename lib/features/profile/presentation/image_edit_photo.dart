import 'dart:io';

import 'package:flutter/material.dart';
import '../../../component/config/app_const.dart';

class ImageEditProfile extends StatelessWidget {
  final double imageBox;
  final String imagePathProfile;

  const ImageEditProfile(
      {super.key, required this.imageBox, required this.imagePathProfile});

  @override
  Widget build(BuildContext context) {
    return imagePathProfile.isEmpty
        ? Container(
            width: imageBox,
            height: imageBox,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AppConst.assetProfile,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          )
        : Container(
            width: imageBox,
            height: imageBox,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(imagePathProfile),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          );
  }
}
