import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:henka_game/data/database_services.dart';
import 'package:henka_game/data/models/questons_model.dart';

abstract class GameController extends GetxController {
  Future<void> fetchQuestions();
}

class GameControllerImpl extends GameController {
  final RxInt teamOneScore = 0.obs;
  final RxInt teamTwoScore = 0.obs;
  final RxBool isLoading = true.obs;

  late final List<String> selectedCategories;
  late final String teamOneName;
  late final String teamTwoName;
  late final double answerTime;

  final RxMap<String, List<QuestionModel>> categoryQuestions =
      <String, List<QuestionModel>>{}.obs;

  GameControllerImpl({
    required this.selectedCategories,
    required this.teamOneName,
    required this.teamTwoName,
    required this.answerTime,
  });

  @override
  void onInit() async {
    dev.log("✅ Selected Categories in GameControllerImpl: $selectedCategories");
    dev.log("✅ Team One Name: $teamOneName");
    dev.log("✅ Team Two Name: $teamTwoName");

    await fetchQuestions();
    super.onInit();
    update();
    Future.delayed(Duration(milliseconds: 500), () {
      Get.forceAppUpdate(); // 🔄 يجبر GetX على إعادة بناء التطبيق بالكامل
    });
  }

  @override
  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      categoryQuestions.clear(); // ✅ مسح أي بيانات قديمة

      for (String category in selectedCategories) {
        dev.log("🔍 Fetching questions for category: $category");

        List<QuestionModel> allQuestions =
            await DatabaseService.getQuestionsByCategory(category);
        dev.log("✅ Questions fetched for $category: ${allQuestions.length}");

        if (allQuestions.isEmpty) {
          dev.log("⚠️ No questions found for category $category");
          continue;
        }

        // ✅ اختيار 10 أسئلة عشوائية وترتيبها حسب النقاط
        List<QuestionModel> selectedQuestions = allQuestions..shuffle();
        selectedQuestions = selectedQuestions.take(10).toList();
        selectedQuestions.sort((a, b) => a.points.compareTo(b.points));

        // ✅ حفظ الأسئلة ضمن الفئة الخاصة بها
        categoryQuestions[category] = selectedQuestions;
        dev.log(
            "📌 Selected and Sorted Questions for $category: ${selectedQuestions.length}");
      }

      dev.log("📌 Final categories loaded: ${categoryQuestions.keys.toList()}");
    } catch (e) {
      dev.log("🚨 ERROR in fetchQuestions: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
