import 'package:get/get.dart';
import 'package:henka_game/controller/category_controller.dart';
import 'package:henka_game/core/constants/routes.dart';

abstract class HomeController extends GetxController {
  goToCategoryPage();
}

class HomeControllerImpl extends HomeController {
  @override
  goToCategoryPage() {
    Get.put<CategoryControllerImpl>(CategoryControllerImpl());
    Get.toNamed(GameRoutes.category);
  }
}
