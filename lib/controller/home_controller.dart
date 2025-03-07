import 'package:get/get.dart';
import 'package:henka_game/core/constants/routes.dart';

abstract class HomeController extends GetxController {
  goToCategoryPage();
}

class HomeControllerImpl extends HomeController {
  @override
  goToCategoryPage() {
    Get.toNamed(GameRoutes.category);
  }
}
