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
  final RxBool isLoading = true.obs; // ✅ مؤشر تحميل

  // ✅ البيانات التي يجب تمريرها
  late final List<String> selectedCategories;
  late final String teamOneName;
  late final String teamTwoName;
  late final double answerTime;

  // ✅ استقبال البيانات عبر الـ Constructor
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
      isLoading.value = true; // ✅ بدأ التحميل
      questions.clear();
      dev.log("📢 Fetching questions for categories: $selectedCategories");

      if (selectedCategories.isEmpty) {
        dev.log("⚠️ تحذير: قائمة الفئات فارغة، لا يمكن جلب الأسئلة.");
        isLoading.value = false;
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

        // ✅ اختيار 10 أسئلة عشوائية بغض النظر عن النقاط
        List<QuestionModel> selectedQuestions = [];
        List<QuestionModel> shuffledQuestions = List.from(allQuestions)
          ..shuffle();

        for (int i = 0; i < min(10, shuffledQuestions.length); i++) {
          selectedQuestions.add(shuffledQuestions[i]);
        }

        // ✅ إضافة الأسئلة المختارة إلى القائمة النهائية
        questions.addAll(selectedQuestions);
        dev.log(
            "📌 Selected questions for $category: ${selectedQuestions.length}");
      }

      dev.log("📌 Final questions loaded: ${questions.length}");
    } catch (e) {
      dev.log("🚨 ERROR in fetchQuestions: $e");
    } finally {
      isLoading.value = false; // ✅ إنهاء التحميل دائمًا
      update();
    }
  }
}
