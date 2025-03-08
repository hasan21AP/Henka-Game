import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/controller/question_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';
import 'package:henka_game/core/functions/en_to_ar.dart';
import 'package:henka_game/data/models/questons_model.dart';
import 'package:henka_game/views/screens/question_view.dart';

class GameBody extends GetView<GameControllerImpl> {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = SizeConfig.screenHeight!;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          // ✅ شريط العنوان والخروج
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.exit_to_app, color: GameColors.second),
                onPressed: () {
                  Get.back();
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "حنكة",
                    style: TextTheme.of(context).titleLarge,
                  ),
                ),
              ),
            ],
          ),
          VerticalSpace(value: 0.3),

          // ✅ عناوين الفئات المختارة
          SizedBox(
            height: screenHeight * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.selectedCategories
                  .map(
                    (category) => Expanded(
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: GameColors.second,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            nameEnToAr(category),
                            textAlign: TextAlign.center,
                            style: TextTheme.of(context).titleSmall!.copyWith(
                                  color: GameColors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          VerticalSpace(value: 0.3),

          // ✅ شبكة الأسئلة
          Expanded(
            flex: 5,
            child: Obx(() {
              return controller.isLoading.value
                  ? Center(
                      child:
                          CircularProgressIndicator(color: GameColors.second))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.selectedCategories.map((category) {
                        List<QuestionModel> categoryList =
                            controller.categoryQuestions[category] ?? [];

                        return Expanded(
                          child: ListView.builder(
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              final question = categoryList[index];

                              return GestureDetector(
                                onTap: () async {
                                  if (Get.isRegistered<
                                      QuestionControllerImpl>()) {
                                    Get.delete<QuestionControllerImpl>();
                                  }
                                  Get.put(QuestionControllerImpl(
                                    question: question.question,
                                    answer: question.answer,
                                    points: question.points,
                                    category: question.category,
                                    answerTime: controller.answerTime,
                                    isTeamOneTurn: controller.isTeamOneTurn,
                                    teamOneName: controller.teamOneName,
                                    teamTwoName: controller.teamTwoName,
                                  ));
                                  String? result =
                                      await Get.to(() => QuestionView());
                                  if (result == "teamOne") {
                                    controller.teamOneScore.value +=
                                        question.points;
                                  } else if (result == "teamTwo") {
                                    controller.teamTwoScore.value +=
                                        question.points;
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: GameColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: GameColors.second, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      question.points.toString(),
                                      style: TextTheme.of(context).titleSmall,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
            }),
          ),

          // ✅ نقل النتيجة إلى الأسفل تمامًا
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreBoard(controller.teamOneName,
                        controller.teamOneScore, context),
                    // ✅ النص في المنتصف ليظهر الفريق الحالي
                    Obx(() => Text(
                          controller.isTeamOneTurn.value
                              ? "دور فريق:  ${controller.teamOneName}"
                              : "دور فريق:  ${controller.teamTwoName}",
                          style: TextTheme.of(context).titleMedium,
                        )),

                    _buildScoreBoard(controller.teamTwoName,
                        controller.teamTwoScore, context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ مكون لوحة النقاط لكل فريق
Widget _buildScoreBoard(String teamName, RxInt score, BuildContext context) {
  return Expanded(
    child: Column(
      children: [
        Text(
          teamName,
          style: TextTheme.of(context).titleSmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: GameColors.second),
              onPressed: () {
                if (score.value > 0) score.value -= 100;
              },
            ),
            Obx(() => Text(
                  score.value.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: GameColors.second),
                )),
            IconButton(
              icon: const Icon(Icons.add, color: GameColors.second),
              onPressed: () {
                score.value += 100;
              },
            ),
          ],
        ),
      ],
    ),
  );
}
