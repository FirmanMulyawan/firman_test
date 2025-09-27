import 'package:firman_dot/features/add_expense/binding/add_expense_binding.dart';
import 'package:firman_dot/features/add_expense/presentation/add_expense_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../features/bottom_nav/binding/bottom_nav_binding.dart';
import '../../features/bottom_nav/presentation/bottom_nav_screen.dart';
import '../../features/detail_product/binding/detail_product_binding.dart';
import '../../features/detail_product/presentation/detail_product_screen.dart';
import '../../features/home/binding/home_binding.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/binding/profile_binding.dart';
import '../../features/profile/presentation/profile_screen.dart';

class AppRoute {
  static const String defaultRoute = '/';
  static const String notFound = '/notFound';
  static const String home = '/home';
  static const String addExpense = '/add-expense';

  static const String profile = '/profile';
  static const String bottomNavHome = '/bottomNavHome';
  static const String detailProduct = '/detail-product';


  static List<GetPage> pages = [
    GetPage(
      name: defaultRoute,
      page: () => const BottomNavScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: detailProduct,
      page: () => const DetailProductScreen(),
      binding: DetailProductBinding(),
    ),
    //
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: addExpense,
      page: () => const AddExpenseScreen(),
      binding: AddExpenseBinding(),
    ),
  ];
}
