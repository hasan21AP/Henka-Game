import 'package:get/get.dart';
import 'package:henka_game/controller/home_controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeControllerImpl>(HomeControllerImpl());
  }
}
