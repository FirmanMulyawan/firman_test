import 'package:get/get.dart';

import '../../../component/util/network.dart';

import '../../products/presentation/products_controller.dart';
import '../../products/repository/products_datasource.dart';
import '../../products/repository/products_respository.dart';
import '../../profile/presentation/profile_controller.dart';
import '../presentation/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());
    Get.lazyPut(() => ProfileController());

    Get.lazyPut(() => ProductsDatasource(Network.dioClient()));
    Get.lazyPut(() => ProductsRepository(Get.find()));
    Get.lazyPut(() => ProductsController(Get.find()));
  }
}
