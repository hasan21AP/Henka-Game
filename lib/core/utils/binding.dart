import 'package:get/get.dart';
import 'package:henka_game/controller/category_controller.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/controller/home_controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeControllerImpl>(() => HomeControllerImpl(), fenix: true);
    Get.lazyPut<CategoryControllerImpl>(() => CategoryControllerImpl(),
        fenix: true);
    Get.lazyPut<GameControllerImpl>(
      () => GameControllerImpl(),
      fenix: true,
    );
  }
}
