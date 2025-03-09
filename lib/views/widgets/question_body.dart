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
              style: TextTheme.of(context).titleMedium,
            ),
            VerticalSpace(value: 2),

            // ✅ زر عرض الإجابة
            CustomElevetedButton(
              text: 'اظهار الإجابة',
              onPressed: () => controller.toggleAnswer(),
              relativisticWidth: 0.2,
              relativisticHeight: 0.08,
              circleRadius: 8,
              mainColor: GameColors.second,
              secondColor: GameColors.white,
              textStyle: TextTheme.of(context).titleSmall,
            ),

            // ✅ إظهار الإجابة عند الضغط على الزر
            Obx(() => controller.showAnswer.value
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      controller.answer,
                      textAlign: TextAlign.center,
                      style: TextTheme.of(context).titleMedium,
                    ),
                  )
                : Container()),

            VerticalSpace(value: 2),

            // ✅ عرض المؤقت
            // ✅ عرض المؤقت أو اسم الفريق حسب الحالة
            Obx(() => Text(
                  controller.isTeamOneTime.value
                      ? "الوقت المتبقي لفريق ${controller.teamOneName} :  ${controller.remainingTime.value} ثانية"
                      : " الوقت المتبقي لفريق ${controller.teamTwoName} : ${controller.remainingTime.value} ثانية",
                  style: TextTheme.of(context).titleMedium,
                )),

            VerticalSpace(value: 2),

            // ✅ زران لإعطاء النقاط لكل فريق
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevetedButton(
                  onPressed: () {
                    controller.stopTimer();
                    controller.isTeamOneTurn.value =
                        !controller.isTeamOneTurn.value;
                    controller.selectResult("${controller.teamOneName} ✅");
                  },
                  text: "إعطاء النقاط لفريق ${controller.teamOneName}",
                  relativisticWidth: 0.1,
                  relativisticHeight: 0.08,
                  circleRadius: 8,
                  mainColor: GameColors.second,
                  secondColor: GameColors.white,
                  textStyle: TextTheme.of(context).titleSmall,
                ),
                CustomElevetedButton(
                  onPressed: () {
                    controller.stopTimer();
                    controller.isTeamOneTurn.value =
                        !controller.isTeamOneTurn.value;
                    controller.selectResult("❌ تعادل");
                  },
                  text: "لم يجب احد من الفريقين",
                  relativisticWidth: 0.1,
                  relativisticHeight: 0.08,
                  circleRadius: 8,
                  mainColor: GameColors.second,
                  secondColor: GameColors.white,
                  textStyle: TextTheme.of(context).titleSmall,
                ),
                CustomElevetedButton(
                  onPressed: () {
                    controller.stopTimer();
                    controller.isTeamOneTurn.value =
                        !controller.isTeamOneTurn.value;
                    controller.selectResult("${controller.teamTwoName} ✅");
                  },
                  text: "إعطاء النقاط لفريق ${controller.teamTwoName}",
                  relativisticWidth: 0.1,
                  relativisticHeight: 0.08,
                  circleRadius: 8,
                  mainColor: GameColors.second,
                  secondColor: GameColors.white,
                  textStyle: TextTheme.of(context).titleSmall,
                ),
              ],
            ),
            VerticalSpace(value: 2),
            Center(
              child: Obx(() => Text(
                    controller.isTeamOneTurn.value
                        ? "دور فريق:  ${controller.teamOneName}"
                        : "دور فريق:  ${controller.teamTwoName}",
                    style: TextTheme.of(context)
                        .titleMedium!
                        .copyWith(color: GameColors.fourth),
                  )),
            ),
          ],
        ));
  }
}
