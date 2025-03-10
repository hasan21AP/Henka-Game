import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/question_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/customs/custom_buttons.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';

class QuestionBody extends GetView<QuestionControllerImpl> {
  const QuestionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Container(
                width: SizeConfig.screenWidth! * 0.95,
                height: SizeConfig.screenHeight! * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: GameColors.white),
                child: Column(children: [
                  // ✅ شريط العنوان والخروج
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth! * 0.2,
                                height: SizeConfig.screenHeight! * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 2, color: GameColors.fourth),
                                ),
                                child: Obx(
                                  () => Text(
                                    controller.isTeamOneTurn.value
                                        ? "دور فريق:  ${controller.teamOneName}"
                                        : "دور فريق:  ${controller.teamTwoName}",
                                    style: TextTheme.of(context)
                                        .titleMedium!
                                        .copyWith(
                                          color: GameColors.fourth,
                                          fontSize:
                                              SizeConfig.screenWidth! * 0.02,
                                        ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                              HorizanintalSpace(value: 2),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenWidth! * 0.005),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      GameColors.main,
                                      GameColors.fourth
                                    ], // 🎨 تحديد الألوان المتدرجة
                                    begin: Alignment.topLeft, // 📍 بداية التدرج
                                    end: Alignment
                                        .bottomRight, // 📍 نهاية التدرج
                                  ).createShader(bounds),
                                  child: Text(
                                    "حنكة",
                                    style: TextTheme.of(context)
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors
                                              .white, // يجب أن يكون اللون أبيض ليأخذ التدرج
                                          fontFamily: 'VIP Arabic Typo',
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              HorizanintalSpace(value: 2)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
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
                        style: TextTheme.of(context).titleMedium!.copyWith(
                              color: GameColors.third,
                            ),
                      ),
                      VerticalSpace(value: 2),

                      // ✅ زر عرض الإجابة
                      CustomElevetedButton(
                        text: 'اظهار الإجابة',
                        onPressed: () => controller.toggleAnswer(),
                        relativisticWidth: 0.2,
                        relativisticHeight: 0.08,
                        circleRadius: 8,
                        mainColor: GameColors.third,
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
                                style:
                                    TextTheme.of(context).titleMedium!.copyWith(
                                          color: GameColors.third,
                                        ),
                              ),
                            )
                          : Container()),

                      VerticalSpace(value: 2),

                      // ✅ عرض المؤقت
                      // ✅ عرض المؤقت أو اسم الفريق حسب الحالة
                      Obx(() => Column(
                            children: [
                              Text(
                                controller.timerText.value,
                                style:
                                    TextTheme.of(context).titleMedium!.copyWith(
                                          color: GameColors.third,
                                        ),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                '${controller.remainingTime} ثانية',
                                style:
                                    TextTheme.of(context).titleMedium!.copyWith(
                                          color: GameColors.third,
                                        ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
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
                              controller
                                  .selectResult("${controller.teamOneName} ✅");
                            },
                            text:
                                "إعطاء النقاط لفريق ${controller.teamOneName}",
                            relativisticWidth: 0.1,
                            relativisticHeight: 0.08,
                            circleRadius: 8,
                            mainColor: GameColors.third,
                            secondColor: GameColors.white,
                            textStyle: TextTheme.of(context).titleSmall,
                          ),
                          CustomElevetedButton(
                            onPressed: () {
                              controller.stopTimer();
                              controller.isTeamOneTurn.value =
                                  !controller.isTeamOneTurn.value;
                              controller.selectResult("تعادل ❌");
                            },
                            text: "لم يجب احد من الفريقين",
                            relativisticWidth: 0.1,
                            relativisticHeight: 0.08,
                            circleRadius: 8,
                            mainColor: GameColors.third,
                            secondColor: GameColors.white,
                            textStyle: TextTheme.of(context).titleSmall,
                          ),
                          CustomElevetedButton(
                            onPressed: () {
                              controller.stopTimer();
                              controller.isTeamOneTurn.value =
                                  !controller.isTeamOneTurn.value;
                              controller
                                  .selectResult("${controller.teamTwoName} ✅");
                            },
                            text:
                                "إعطاء النقاط لفريق ${controller.teamTwoName}",
                            relativisticWidth: 0.1,
                            relativisticHeight: 0.08,
                            circleRadius: 8,
                            mainColor: GameColors.third,
                            secondColor: GameColors.white,
                            textStyle: TextTheme.of(context).titleSmall,
                          ),
                        ],
                      ),
                    ],
                  )
                ]))));
  }
}
