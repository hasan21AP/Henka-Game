import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/core/constants/images.dart';
import 'package:henka_game/core/constants/routes.dart';
import 'package:henka_game/data/database.dart';
import 'package:sqflite/sqflite.dart';

abstract class CategoryController extends GetxController {
  goToGamePage();
}

class CategoryControllerImpl extends CategoryController {
  final RxList<String> categories = <String>[].obs;
  List<String> images = [
    GameImages.anime,
    GameImages.football,
    GameImages.religious,
    GameImages.history,
    GameImages.moviesSeries,
    GameImages.science,
    GameImages.quran,
  ];
  final RxMap<String, bool> selectedCategories = <String, bool>{}.obs;
  final RxDouble answerTime = 60.0.obs;
  final RxInt numberOfCategorySelected = 0.obs;
  final RxString teamOneName = ''.obs;
  final RxString teamTwoName = ''.obs;

  UniqueKey teamOneKey = UniqueKey();
  UniqueKey teamTwoKey = UniqueKey();
  TextEditingController teamOneController = TextEditingController();
  TextEditingController teamTwoController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await fetchCategoriesFromDatabase();
  }

  @override
  goToGamePage() async {
    await Future.delayed(Duration(milliseconds: 800), () {
      Get.delete<CategoryControllerImpl>(); // ✅ حذف الكونترولر
      Get.toNamed(GameRoutes.game);
    });
  }

  Future<void> fetchCategoriesFromDatabase() async {
    await Future.delayed(Duration(seconds: 2), () {});
    try {
      final Database db = await DatabaseHelper.database;

      List<Map<String, dynamic>> tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");

      if (tables.isEmpty) {
        log("[ERROR] لا توجد جداول في قاعدة البيانات!");
        return;
      }

      // ✅ تحديث `categories` مباشرةً باستخدام `RxList`
      categories
          .assignAll(tables.map((table) => table['name'] as String).toList());

      // ✅ ضبط الحالة الافتراضية للفئات على `false`
      selectedCategories.clear();
      for (String category in categories) {
        selectedCategories[category] = false;
      }

      log("[LOG] الفئات المحملة من قاعدة البيانات: $categories");
    } catch (e) {
      log("[ERROR] فشل تحميل الفئات: $e");
    }
  }

  @override
  void onClose() {
    teamOneKey = UniqueKey(); // إعادة تعيين المفتاح عند الإغلاق
    teamTwoKey = UniqueKey(); // إعادة تعيين المفتاح عند الإغلاق
    super.onClose();
  }
}

// ✅ **دالة لجلب أسماء الجداول (الفئات) من قاعدة البيانات**
