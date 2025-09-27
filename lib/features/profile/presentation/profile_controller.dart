import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notification_center/notification_center.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../component/database/database.dart';
import '../../../component/widget/overlay_widget.dart';

class ProfileController extends GetxController {
  bool isValid = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image;
  String? imagePathProfile;

  String? phoneErrorMessage;
  String? emailErrorMessage;

  // database profile
  DatabaseManager database = DatabaseManager.instance;
  ProfileController();

  @override
  void onInit() {
    getProfile();
    NotificationCenter().subscribe('refresh-profile', (_) {
      getProfile();
      update();
    });
    super.onInit();
  }

  void clearPhoneError() {
    phoneErrorMessage = null;
    update();
  }

  void clearEmailError() {
    emailErrorMessage = null;
    update();
  }

  void validate() {
    isValid = nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        EmailValidator.validate(emailController.text) &&
        imagePathProfile != null;

    update();
  }

  void setImageFromGallery() async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      Get.back();
      final imagePath = XFile(image?.path ?? '');
      imagePathProfile = imagePath.path;
      update();
      validate();
    } catch (_) {}
  }

  Future<void> saveEditProfile() async {
    final name = nameController.text;
    final phone = phoneController.text;
    final email = emailController.text;
    final imagePath = imagePathProfile ?? '';
    showLoading();
    Database db = await database.db;
    final existing = await db.query("profile", limit: 1);

    if (existing.isEmpty) {
      await db.insert("profile", {
        "name": name,
        "phoneNumber": phone,
        "email": email,
        "imagePath": imagePath,
      });
    } else {
      await db.update(
        "profile",
        {
          "name": name,
          "phoneNumber": phone,
          "email": email,
          "imagePath": imagePath,
        },
        where: "id = ?",
        whereArgs: [1],
      );
    }
    NotificationCenter().notify('refresh-profile');
    hideLoading();
    update();
  }

  Future<Map<String, dynamic>?> getProfile() async {
    Database db = await DatabaseManager.instance.db;

    final List<Map<String, dynamic>> result = await db.query(
      "profile",
      limit: 1,
    );

    if (result.isNotEmpty) {
      nameController.text = result.first['name'] ?? '';
      phoneController.text = result.first['phoneNumber'] ?? '';
      emailController.text = result.first['email'] ?? '';
      imagePathProfile = result.first['imagePath'] ?? '';
      validate();
      return result.first;
    } else {
      return null;
    }
  }
}
