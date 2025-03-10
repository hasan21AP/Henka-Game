import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/controller/question_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/constants/images.dart';
import 'package:henka_game/core/constants/routes.dart';
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
      child: Center(
        child: Container(
          width: SizeConfig.screenWidth! * 0.95,
          height: SizeConfig.screenHeight! * 0.95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: GameColors.white),
          child: Column(
            children: [
              // ✅ شريط العنوان والخروج
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(GameRoutes.category);
                      },
                      child: Image.asset(
                        GameImages.exit,
                        width: SizeConfig.screenWidth! * 0.1,
                        height: SizeConfig.screenHeight! * 0.06,
                      ),
                    ),
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
                                      fontSize: SizeConfig.screenWidth! * 0.02,
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
                                end: Alignment.bottomRight, // 📍 نهاية التدرج
                              ).createShader(bounds),
                              child: Text(
                                "حنكة",
                                style:
                                    TextTheme.of(context).titleLarge!.copyWith(
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
                              color: GameColors.third,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                nameEnToAr(category),
                                textAlign: TextAlign.center,
                                style:
                                    TextTheme.of(context).titleSmall!.copyWith(
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
                          child: CircularProgressIndicator(
                              color: GameColors.second))
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              controller.selectedCategories.map((category) {
                            List<QuestionModel> categoryList =
                                controller.categoryQuestions[category] ?? [];

                            return Expanded(
                              child: ListView.builder(
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) {
                                  final QuestionModel question =
                                      categoryList[index];
                                  String questionKey =
                                      "${category}_${question.points}_${question.question.hashCode}";

                                  bool isAnswered = controller.answeredQuestions
                                      .containsKey(questionKey);
                                  String? resultText =
                                      controller.answeredQuestions[questionKey];

                                  return GestureDetector(
                                    onTap: isAnswered
                                        ? null
                                        : () async {
                                            if (Get.isRegistered<
                                                QuestionControllerImpl>()) {
                                              Get.delete<
                                                  QuestionControllerImpl>();
                                            }
                                            Get.put(QuestionControllerImpl(
                                              question: question.question,
                                              answer: question.answer,
                                              points: question.points,
                                              category: question.category,
                                              answerTime: controller.answerTime,
                                              isTeamOneTurn:
                                                  controller.isTeamOneTurn,
                                              teamOneName:
                                                  controller.teamOneName,
                                              teamTwoName:
                                                  controller.teamTwoName,
                                            ));
                                            String? result = await Get.to(
                                                () => QuestionView());
                                            if (result != null) {
                                              controller
                                                  .updateAnsweredQuestions(
                                                      questionKey,
                                                      result,
                                                      question.points);
                                            }
                                          },
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      padding: isAnswered
                                          ? EdgeInsets.all(4)
                                          : EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isAnswered
                                            ? GameColors.third
                                            : GameColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: isAnswered
                                                ? GameColors.white
                                                : GameColors.third,
                                            width: 1),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // ✅ يجعل النصوص في المنتصف عموديًا
                                          children: [
                                            if (isAnswered) // ✅ عرض اسم الفريق الذي أجاب فقط عند الإجابة
                                              Text(
                                                resultText ?? "",
                                                style: TextTheme.of(context)
                                                    .titleSmall!
                                                    .copyWith(
                                                      color: GameColors.white,
                                                      fontSize: isAnswered
                                                          ? SizeConfig
                                                                  .screenHeight! *
                                                              0.0175
                                                          : SizeConfig
                                                                  .screenHeight! *
                                                              0.025,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            Text(
                                              question.points.toString(),
                                              style: TextTheme.of(context)
                                                  .titleSmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight
                                                        .bold, // ✅ جعل الرقم بارزًا // ✅ تعديل حجم الخط ليكون أوضح
                                                    color: isAnswered
                                                        ? GameColors.white
                                                        : GameColors.third,
                                                    fontSize: isAnswered
                                                        ? SizeConfig
                                                                .screenHeight! *
                                                            0.0175
                                                        : SizeConfig
                                                                .screenHeight! *
                                                            0.025,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
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
              VerticalSpace(value: 1),
              // ✅ نقل النتيجة إلى الأسفل تمامًا
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreBoard(controller.teamOneName,
                        controller.teamOneScore, context),
                    // ✅ النص في المنتصف ليظهر الفريق الحالي

                    _buildScoreBoard(controller.teamTwoName,
                        controller.teamTwoScore, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ مكون لوحة النقاط لكل فريق
Widget _buildScoreBoard(String teamName, RxInt score, BuildContext context) {
  return Expanded(
    child: Column(
      children: [
        Stack(
          alignment:
              Alignment.center, // يجعل العناصر في منتصف الـ Stack تلقائيًا
          children: [
            // ✅ الصورة الخلفية
            Container(
              width: SizeConfig.screenWidth! * 0.1,
              height: SizeConfig.screenHeight! * 0.07,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(GameImages.teamName),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ✅ النص في المنتصف
            Align(
              alignment: Alignment.center, // يضمن بقاء النص في منتصف الصورة
              child: Text(
                teamName,
                style: TextTheme.of(context).titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        VerticalSpace(value: 0.5),
        Container(
          width: SizeConfig.screenWidth! * 0.15,
          height: SizeConfig.screenHeight! * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: GameColors.fourth),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () => score.value > 0 ? score.value -= 100 : 0,
                  child: Image.asset(
                    GameImages.minus,
                    width: SizeConfig.screenWidth! * 0.03,
                    height: SizeConfig.screenHeight! * 0.04,
                  )),
              Obx(() => Text(
                    score.value.toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GameColors.third),
                  )),
              GestureDetector(
                  onTap: () => score.value += 100,
                  child: Image.asset(
                    GameImages.plus,
                    width: SizeConfig.screenWidth! * 0.03,
                    height: SizeConfig.screenHeight! * 0.04,
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}
