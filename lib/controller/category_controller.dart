import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/core/constants/images.dart';
import 'package:henka_game/core/constants/routes.dart';
import 'package:henka_game/data/database.dart';
import 'package:sqflite/sqflite.dart';

abstract class CategoryController extends GetxController {
  goToGamePage();
  validation();
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
    GameImages.wwe,
  ];
  final RxMap<String, bool> selectedCategories = <String, bool>{}.obs;
  final RxDouble answerTime = 60.0.obs;
  final RxInt numberOfCategorySelected = 0.obs;
  final RxString teamOneName = ''.obs;
  final RxString teamTwoName = ''.obs;
  RxBool isValid = false.obs;

  GlobalKey<FormState> teamOneKey = GlobalKey<FormState>();
  GlobalKey<FormState> teamTwoKey = GlobalKey<FormState>();
  TextEditingController teamOneController = TextEditingController();
  TextEditingController teamTwoController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await fetchCategoriesFromDatabase();
  }

  @override
  goToGamePage() {
    Get.delete<CategoryControllerImpl>(); // ✅ حذف الكونترولر
    Get.offAllNamed(GameRoutes.game);
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
    teamOneKey = GlobalKey<FormState>(); // إعادة تعيين المفتاح عند الإغلاق
    teamTwoKey = GlobalKey<FormState>(); // إعادة تعيين المفتاح عند الإغلاق
    super.onClose();
  }

  @override
  validation() {
    final teamOneState = teamOneKey.currentState;
    final teamTwoState = teamTwoKey.currentState;

    // ✅ تحقق مما إذا كان أي مفتاح لم يتم ربطه بعد
    if (teamOneState == null || teamTwoState == null) {
      return false;
    }

    return teamOneState.validate() && teamTwoState.validate();
  }
}

// ✅ **دالة لجلب أسماء الجداول (الفئات) من قاعدة البيانات**
