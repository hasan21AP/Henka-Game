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
    double screenWidth = SizeConfig.screenWidth!;

    int columnCount = controller.selectedCategories.length;
    int rowCount = controller.questions.length ~/ columnCount;

    double itemWidth = screenWidth / columnCount;
    double itemHeight =
        screenHeight / (rowCount + 2); // ✅ توزيع الارتفاع بشكل أفضل

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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GameColors.second,
                    ),
                  ),
                ),
              ),
            ],
          ),
          VerticalSpace(value: 0.3), // ✅ تقليل المسافة العلوية

          // ✅ عناوين الفئات المختارة
          SizedBox(
            height: screenHeight * 0.08, // ✅ تحديد ارتفاع مناسب ديناميكيًا
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
                            style: TextStyle(
                              color: GameColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          VerticalSpace(value: 0.3), // ✅ تقليل المسافة العلوية

          Expanded(
            flex: 5, // ✅ السماح للشبكة بأخذ معظم الشاشة
            child: Obx(() {
              List<QuestionModel> sortedQuestions =
                  controller.questions.toList();
              sortedQuestions.sort((a, b) => a.points.compareTo(b.points));

              return controller.isLoading.value
                  ? Center(
                      child:
                          CircularProgressIndicator(color: GameColors.second))
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        childAspectRatio: (itemWidth * 1.3) /
                            itemHeight, // ✅ تحسين أبعاد البطاقات
                      ),
                      itemCount: sortedQuestions.length,
                      itemBuilder: (context, index) {
                        final QuestionModel question = sortedQuestions[index];

                        return GestureDetector(
                          onTap: () async {
                            if (Get.isRegistered<QuestionControllerImpl>()) {
                              Get.delete<QuestionControllerImpl>();
                            }
                            Get.put(QuestionControllerImpl(
                                question: question.question,
                                answer: question.answer,
                                points: question.points,
                                category: question.category,
                                answerTime: controller.answerTime));
                            String? result = await Get.to(() => QuestionView());
                            if (result == "teamOne") {
                              controller.teamOneScore.value += question.points;
                            } else if (result == "teamTwo") {
                              controller.teamTwoScore.value += question.points;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: GameColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: GameColors.second, width: 2),
                            ),
                            margin: EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                question.points.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: GameColors.second,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
          ),

          // ✅ نقل النتيجة إلى الأسفل تمامًا
          Expanded(
            flex: 1, // ✅ مساحة أصغر للنتائج
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0), // ✅ تقليل الفراغ السفلي
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreBoard(
                        controller.teamOneName, controller.teamOneScore),
                    _buildScoreBoard(
                        controller.teamTwoName, controller.teamTwoScore),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ مكون لوحة النقاط لكل فريق
  Widget _buildScoreBoard(String teamName, RxInt score) {
    return Expanded(
      child: Column(
        children: [
          Text(
            teamName,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GameColors.second),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: GameColors.second),
                onPressed: () {
                  if (score.value > 0) score.value -= 100;
                },
              ),
              Obx(() => Text(
                    score.value.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GameColors.second),
                  )),
              IconButton(
                icon: Icon(Icons.add, color: GameColors.second),
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
}
