import 'package:get/get.dart';
import 'package:henka_game/controller/category_controller.dart';
import 'package:henka_game/controller/home_controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeControllerImpl>(HomeControllerImpl());
    Get.put<CategoryControllerImpl>(CategoryControllerImpl());
  }
}
