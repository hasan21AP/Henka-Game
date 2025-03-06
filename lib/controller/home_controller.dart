import 'package:get/get.dart';

abstract class HomeController extends GetxController {
  goToCategoryPage();
}

class HomeControllerImpl extends HomeController {
  @override
  goToCategoryPage() {
    Get.toNamed('/category');
  }
}
