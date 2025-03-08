import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/question_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/customs/custom_buttons.dart';
import 'package:henka_game/core/customs/custom_space.dart';

class QuestionBody extends GetView<QuestionControllerImpl> {
  const QuestionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'السؤال',
              style: TextTheme.of(context).titleLarge,
            ),
            // ✅ عرض السؤال
            Text(
              controller.question,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GameColors.second,
              ),
            ),
            VerticalSpace(value: 2),

            // ✅ زر عرض الإجابة
            CustomElevetedButton(
              text: 'اظهار الإجابة',
              onPressed: () => controller.toggleAnswer(),
              relativisticWidth: 0.3,
              relativisticHeight: 0.08,
              circleRadius: 8,
              mainColor: GameColors.second,
              secondColor: GameColors.white,
            ),

            // ✅ إظهار الإجابة عند الضغط على الزر
            Obx(() => controller.showAnswer.value
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      controller.answer,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: GameColors.second),
                    ),
                  )
                : Container()),

            VerticalSpace(value: 2),

            // ✅ عرض المؤقت
            Obx(() => Text(
                  "الوقت المتبقي: ${controller.remainingTime.value} ثانية",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),

            VerticalSpace(value: 2),

            // ✅ زران لإعطاء النقاط لكل فريق
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevetedButton(
                  onPressed: () {
                    controller.stopTimer();
                    Get.back(result: "teamOne");
                  },
                  text: "إعطاء النقاط للفريق الاول",
                  relativisticWidth: 0.1,
                  relativisticHeight: 0.08,
                  circleRadius: 8,
                  mainColor: GameColors.second,
                  secondColor: GameColors.white,
                ),
                CustomElevetedButton(
                  onPressed: () {
                    controller.stopTimer();
                    Get.back(result: "teamTwo");
                  },
                  text: "إعطاء النقاط للفريق الثاني",
                  relativisticWidth: 0.1,
                  relativisticHeight: 0.08,
                  circleRadius: 8,
                  mainColor: GameColors.second,
                  secondColor: GameColors.white,
                ),
              ],
            ),
          ],
        ));
  }
}
