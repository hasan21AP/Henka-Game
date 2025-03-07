import 'dart:developer' as dev;
import 'dart:math';
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

      // ✅ توزيع النقاط المطلوبة لكل فئة
      Map<int, int> requiredQuestionsPerLevel = {
        100: 4,
        200: 2,
        400: 2,
        500: 1,
        1000: 1,
      };

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

        // ✅ اختيار 10 أسئلة عشوائية من المستويات المطلوبة
        List<int> levels = [
          1000,
          500,
          400,
          200,
          100
        ]; // ترتيب المستويات حسب الأولوية
        List<QuestionModel> selectedQuestions = [];

        for (var level in levels) {
          if (requiredQuestionsPerLevel.containsKey(level)) {
            int requiredCount = requiredQuestionsPerLevel[level]!;
            List<QuestionModel> availableQuestions =
                groupedQuestions[level] ?? [];

            while (selectedQuestions.length < 10 && requiredCount > 0) {
              if (availableQuestions.isNotEmpty) {
                int randomIndex = Random().nextInt(availableQuestions.length);
                selectedQuestions.add(availableQuestions[randomIndex]);
                availableQuestions.removeAt(randomIndex);
                requiredCount--;
              } else {
                // ✅ إذا لم تتوفر أسئلة في هذا المستوى، استخدم المستوى الذي قبله
                int currentIndex = levels.indexOf(level);
                if (currentIndex < levels.length - 1) {
                  int fallbackLevel = levels[currentIndex + 1];
                  availableQuestions = groupedQuestions[fallbackLevel] ?? [];
                } else {
                  break; // لا يوجد مستويات أخرى للرجوع إليها
                }
              }
            }
          }
        }

        // ✅ إضافة الأسئلة المختارة إلى القائمة النهائية
        questions.addAll(selectedQuestions);
        dev.log(
            "📌 Selected questions for $category: ${selectedQuestions.length}");
      }

      dev.log("📌 Final questions loaded: ${questions.length}");
    } catch (e) {
      dev.log("🚨 ERROR in fetchQuestions: $e");
    }
  }
}
