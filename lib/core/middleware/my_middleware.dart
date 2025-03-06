import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/core/services/my_services.dart';

class MyMiddleware extends GetMiddleware {
  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    return null;
  }
}
