import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/category_controller.dart';
import 'package:henka_game/core/audio/audio_services.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/constants/routes.dart';
import 'package:henka_game/core/customs/custom_buttons.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';
import 'package:henka_game/data/database_services.dart';
import 'package:henka_game/data/models/questons_model.dart';

abstract class GameController extends GetxController {
  Future<void> fetchQuestions();
  void updateAnsweredQuestions(String questionKey, String result, int points);
}

class GameControllerImpl extends GameController {
  final RxInt teamOneScore = 0.obs;
  final RxInt teamTwoScore = 0.obs;
  final RxInt teamOneAnsweredCount = 0.obs; // ✅ عدد الأسئلة المجابة لفريق 1
  final RxInt teamTwoAnsweredCount = 0.obs; // ✅ عدد الأسئلة المجابة لفريق 2
  final RxInt drawCount = 0.obs; // ✅ عدد الأسئلة التي انتهت بالتعادل
  final RxBool isLoading = true.obs;
  RxBool isTeamOneTurn = true.obs; // ✅ تتبع دور الفريق الحالي

  final RxMap<String, String> answeredQuestions = <String, String>{}.obs;

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
    await fetchQuestions();
    super.onInit();
    Get.forceAppUpdate(); // 🔄 يجبر GetX على إعادة بناء التطبيق بالكامل
  }

  @override
  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      categoryQuestions.clear();
      answeredQuestions.clear();
      teamOneAnsweredCount.value = 0;
      teamTwoAnsweredCount.value = 0;
      drawCount.value = 0;

      for (String category in selectedCategories) {
        List<QuestionModel> allQuestions =
            await DatabaseService.getQuestionsByCategory(category);
        if (allQuestions.isEmpty) continue;

        List<QuestionModel> selectedQuestions = allQuestions..shuffle();
        selectedQuestions = selectedQuestions.take(5).toList();
        selectedQuestions.sort((a, b) => a.points.compareTo(b.points));

        categoryQuestions[category] = selectedQuestions;
      }
    } catch (e) {
      dev.log("🚨 ERROR in fetchQuestions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void updateAnsweredQuestions(String questionKey, String result, int points) {
    answeredQuestions[questionKey] = result;

    if (result == "$teamOneName ✅") {
      teamOneScore.value += points;
      teamOneAnsweredCount.value += 1;
    } else if (result == "$teamTwoName ✅") {
      teamTwoScore.value += points;
      teamTwoAnsweredCount.value += 1;
    } else {
      drawCount.value += 1;
    }

    // ✅ التحقق إذا كانت جميع الأسئلة قد تم الإجابة عليها
    if (answeredQuestions.length == totalQuestionsCount) {
      showWinnerDialog();
    }

    Get.forceAppUpdate();
  }

  int get totalQuestionsCount {
    return categoryQuestions.values.fold(0, (sum, list) => sum + list.length);
  }

  // ✅ إظهار نافذة الفريق الفائز عند انتهاء اللعبة
  void showWinnerDialog() async {
    String winner;
    if (teamOneScore.value > teamTwoScore.value) {
      winner = teamOneName;
    } else if (teamTwoScore.value > teamOneScore.value) {
      winner = teamTwoName;
    } else {
      winner = "تعادل!";
    }

    Get.dialog(
      AlertDialog(
        title: Text(
          "🎉 تهانينا!",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [GameColors.main, GameColors.fourth],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text("الفائز: $winner",
                  style: TextStyle(
                    fontFamily: 'VIP Arabic Typo',
                    fontSize: SizeConfig.screenHeight! * 0.035,
                  )),
            ),
            VerticalSpace(value: 2),
            Text("✅ إجابات $teamOneName: ${teamOneAnsweredCount.value}",
                style: TextTheme.of(Get.context!).titleSmall!.copyWith(
                      color: GameColors.fourth,
                      fontSize: SizeConfig.screenHeight! * 0.03,
                    )),
            Text("✅ إجابات $teamTwoName: ${teamTwoAnsweredCount.value}",
                style: TextTheme.of(Get.context!).titleSmall!.copyWith(
                      color: GameColors.fourth,
                      fontSize: SizeConfig.screenHeight! * 0.03,
                    )),
            Text("⚖️ تعادل: ${drawCount.value}",
                style: TextTheme.of(Get.context!).titleSmall!.copyWith(
                      color: GameColors.fourth,
                      fontSize: SizeConfig.screenHeight! * 0.03,
                    )),
            Text("🏆 النقاط النهائية"),
            Text("$teamOneName: ${teamOneScore.value}",
                style: TextTheme.of(Get.context!).titleSmall!.copyWith(
                      color: GameColors.fourth,
                      fontSize: SizeConfig.screenHeight! * 0.03,
                    )),
            Text("$teamTwoName: ${teamTwoScore.value}",
                style: TextTheme.of(Get.context!).titleSmall!.copyWith(
                      color: GameColors.fourth,
                      fontSize: SizeConfig.screenHeight! * 0.03,
                    )),
          ],
        ),
        actions: [
          CustomButton(
              text: "العودة إلى القائمة",
              onTap: () {
                Get.delete<GameControllerImpl>();
                Get.delete<CategoryControllerImpl>();
                Get.offAllNamed(GameRoutes.home);
              },
              mainColor: GameColors.third,
              secondColor: GameColors.white,
              relativisticWidth: 0.2,
              relativisticHeight: 0.05,
              circleRadius: 8,
              textStyle: TextTheme.of(Get.context!).titleSmall!),
        ],
      ),
      barrierDismissible: false,
    );
    await AudioService.playWinningMusic();
  }
}
