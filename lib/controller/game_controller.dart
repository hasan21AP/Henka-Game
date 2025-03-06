import 'dart:math';
import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:henka_game/data/database_services.dart';
import 'package:henka_game/data/models/questons_model.dart';

abstract class GameController {
  Future<void> fetchQuestions();
}

class GameControllerImpl extends GetxController implements GameController {
  final RxInt teamOneScore = 0.obs;
  final RxInt teamTwoScore = 0.obs;
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;

  final List<String>
      selectedCategories; // ✅ حفظ الفئات المختارة عند التنقل من CategoryBody
  GameControllerImpl(List<String>? categories)
      : selectedCategories = categories ?? [] {
    dev.log("✅ Received Categories in GameControllerImpl: $selectedCategories");

    // ✅ تحقق مما إذا كانت القائمة فارغة أو تحتوي على null
    if (categories == null) {
      dev.log("🚨 ERROR: categories is NULL");
    } else if (categories.isEmpty) {
      dev.log("🚨 ERROR: categories is EMPTY");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchQuestions();
    dev.log(
        'Selected Categories:$selectedCategories'); // ✅ جلب الأسئلة عند دخول الصفحة
  }

  @override
  Future<void> fetchQuestions() async {
    try {
      questions.clear();
      dev.log("📢 Fetching questions for categories: $selectedCategories");

      for (String category in selectedCategories) {
        dev.log("🔍 Fetching questions for category: $category");

        // ✅ **جلب الأسئلة لكل فئة من الجدول الخاص بها**
        List<QuestionModel> allQuestions =
            await DatabaseService.getQuestionsByCategory(category);

        dev.log("✅ Questions fetched for $category: ${allQuestions.length}");

        if (allQuestions.isEmpty) {
          dev.log("⚠️ WARNING: No questions found for category $category");
        }

        // ✅ **تصنيف الأسئلة حسب النقاط**
        Map<int, List<QuestionModel>> groupedQuestions = {};
        for (var question in allQuestions) {
          groupedQuestions.putIfAbsent(question.points, () => []).add(question);
        }

        dev.log("✅ Grouped questions: $groupedQuestions");

        // ✅ **تحديد العدد المطلوب لكل مستوى**
        List<int> requiredPoints = [
          100,
          100,
          100,
          100,
          200,
          200,
          400,
          400,
          500,
          1000
        ];

        for (int points in requiredPoints) {
          if (groupedQuestions.containsKey(points) &&
              groupedQuestions[points]!.isNotEmpty) {
            List<QuestionModel> pointQuestions = groupedQuestions[points]!;

            // ✅ **اختيار سؤال عشوائي إذا كان هناك أكثر من سؤال في هذا المستوى**
            QuestionModel selectedQuestion =
                pointQuestions[Random().nextInt(pointQuestions.length)];

            questions.add(selectedQuestion);

            // ✅ **إزالة السؤال المختار لتجنب التكرار**
            groupedQuestions[points]!.remove(selectedQuestion);
          }
        }
      }

      dev.log("📌 Final questions loaded: ${questions.length}");
    } catch (e) {
      dev.log("🚨 ERROR in fetchQuestions: $e");
    }
  }
}
