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
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;

  // ✅ البيانات التي يجب تمريرها
  late final List<String> selectedCategories;
  late final String teamOneName;
  late final String teamTwoName;

  // ✅ استقبال البيانات عبر الـ Constructor
  GameControllerImpl({
    required this.selectedCategories,
    required this.teamOneName,
    required this.teamTwoName,
  });

  @override
  void onInit() async {
    super.onInit();
    dev.log("✅ Selected Categories in GameControllerImpl: $selectedCategories");
    dev.log("✅ Team One Name: $teamOneName");
    dev.log("✅ Team Two Name: $teamTwoName");
    if (selectedCategories.isNotEmpty) {
      await fetchQuestions();
    } else {
      dev.log("⚠️ تحذير: قائمة الفئات فارغة، تأكد من تمريرها بشكل صحيح!");
    }
  }

  @override
  Future<void> fetchQuestions() async {
    try {
      questions.clear();
      dev.log("📢 Fetching questions for categories: $selectedCategories");

      if (selectedCategories.isEmpty) {
        dev.log("⚠️ تحذير: قائمة الفئات فارغة، لا يمكن جلب الأسئلة.");
        return;
      }

      for (String category in selectedCategories) {
        dev.log("🔍 Fetching questions for category: $category");

        List<QuestionModel> allQuestions =
            await DatabaseService.getQuestionsByCategory(category);

        dev.log("✅ Questions fetched for $category: ${allQuestions.length}");

        if (allQuestions.isEmpty) {
          dev.log("⚠️ WARNING: No questions found for category $category");
          continue;
        }

        // ✅ تصنيف الأسئلة حسب النقاط
        Map<int, List<QuestionModel>> groupedQuestions = {};
        for (var question in allQuestions) {
          groupedQuestions.putIfAbsent(question.points, () => []).add(question);
        }

        // ✅ إضافة الأسئلة إلى القائمة
        groupedQuestions.forEach((points, questionsList) {
          if (questionsList.isNotEmpty) {
            questions.add(questionsList.first);
          }
        });
      }

      dev.log("📌 Final questions loaded: ${questions.length}");
    } catch (e) {
      dev.log("🚨 ERROR in fetchQuestions: $e");
    }
  }
}
