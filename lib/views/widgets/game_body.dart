import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/functions/en_to_ar.dart';
import 'package:henka_game/views/screens/question_view.dart';

class GameBody extends GetView<GameControllerImpl> {
  const GameBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log("Questions Loaded: ${controller.questions.length}");

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;

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
              VerticalSpace(value: 0.5),

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
              VerticalSpace(value: 0.5),

              // ✅ شبكة الأسئلة
              Expanded(
                child: Obx(() {
                  if (controller.questions.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: GameColors.second,
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // تعطيل التمرير
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.selectedCategories.length,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => QuestionView(
                                category: question.category,
                                value: question.points,
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: GameColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: GameColors.second, width: 2),
                          ),
                          margin:
                              EdgeInsets.all(2), // تقليل الفراغ بين البطاقات
                          child: Center(
                            child: Text(
                              question.points.toString(), // ✅ عرض النقاط فقط
                              style: TextStyle(
                                fontSize: 18,
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

              VerticalSpace(value: 0.5),

              // ✅ لوحة النقاط
              Flexible(
                flex: 1,
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
            ],
          ),
        );
      },
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
