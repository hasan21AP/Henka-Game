import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/category_controller.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/constants/images.dart';
import 'package:henka_game/core/constants/routes.dart';
import 'package:henka_game/core/customs/custom_buttons.dart';
import 'package:henka_game/core/customs/custom_forms.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';
import 'package:henka_game/core/functions/en_to_ar.dart';

class CategoryBody extends GetView<CategoryControllerImpl> {
  const CategoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    log("Number of Categories:  ${controller.numberOfCategorySelected.value}");
    return Padding(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.01),
        child: Obx(() => controller.categories.length < 7
            ? Center(
                child: CircularProgressIndicator(
                color: GameColors.third,
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      width: SizeConfig.screenWidth! * 0.95,
                      height: SizeConfig.screenHeight! * 0.95,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: GameColors.white),
                      child: Column(
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomBackButton(
                                    onTap: () {
                                      Get.toNamed(GameRoutes.home);
                                    },
                                    image: GameImages.back,
                                    width: 0.1,
                                    height: 0.06),
                                Stack(
                                  alignment: Alignment
                                      .center, // يجعل كل العناصر داخل Stack في المنتصف
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth! * 0.18,
                                      height: SizeConfig.screenHeight! * 0.09,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            GameColors.main, // اللون الأول
                                            GameColors.fourth, // اللون الثاني
                                          ],
                                          begin: Alignment
                                              .centerLeft, // اتجاه التدرج من اليسار إلى اليمين
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          'اختر الفئات',
                                          style:
                                              TextTheme.of(context).titleMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.screenWidth! * 0.005),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        GameColors.main,
                                        GameColors.fourth
                                      ], // 🎨 تحديد الألوان المتدرجة
                                      begin:
                                          Alignment.topLeft, // 📍 بداية التدرج
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
                              ],
                            ),
                          ),
                          VerticalSpace(value: 2),
                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // منع التمرير داخل GridView لأنه داخل ListView
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: controller.categories
                                  .length, // عدد الأعمدة (يمكنك تغييره إلى 3 لجعل البطاقات أصغر)
                              crossAxisSpacing: 8, // تقليل المسافات بين الأعمدة
                              mainAxisSpacing: 8, // تقليل المسافات بين الصفوف
                              childAspectRatio:
                                  0.8, // تقليل نسبة العرض إلى الارتفاع لتصغير البطاقات
                            ),
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              String category = controller.categories[index];
                              return GestureDetector(
                                onTap: () {
                                  controller.selectedCategories[category] =
                                      !controller.selectedCategories[category]!;

                                  controller.numberOfCategorySelected.value =
                                      controller.selectedCategories.values
                                          .where((value) => value)
                                          .length;
                                },
                                child: Obx(
                                  () => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: GameColors.third,
                                        width: 3,
                                      ),
                                      color: controller
                                              .selectedCategories[category]!
                                          ? GameColors.third
                                          : GameColors.white,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        // ✅ الصورة داخل البطاقة
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.asset(
                                            controller.images[index],
                                            fit: BoxFit
                                                .cover, // ✅ يجعل الصورة تغطي كامل البطاقة بشكل مناسب
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),

                                        controller.selectedCategories[category]!
                                            ? Center(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width:
                                                      SizeConfig.screenWidth! *
                                                          0.2,
                                                  height:
                                                      SizeConfig.screenHeight! *
                                                          0.1,
                                                  child: Image.asset(
                                                      GameImages.check),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        // ✅ شريط سفلي يحتوي على اسم الفئة
                                        Container(
                                          height: 35,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: GameColors.third.withValues(
                                                alpha:
                                                    .8), // ✅ لون داكن مع شفافية
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(9),
                                              bottomRight: Radius.circular(9),
                                            ),
                                          ),
                                          child: Text(
                                            nameEnToAr(category),
                                            style: TextStyle(
                                              fontSize:
                                                  SizeConfig.screenWidth! *
                                                      0.02,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          VerticalSpace(value: 1),
                          Text("اختر زمن الإجابة (بالثواني):",
                              style: TextTheme.of(context).titleLarge!.copyWith(
                                    color: GameColors.third,
                                    fontSize: SizeConfig.screenWidth! * 0.02,
                                  )),
                          Slider(
                            value: controller.answerTime.value,
                            min: 60,
                            max: 300,
                            divisions: 4,
                            activeColor: GameColors.fourth,
                            inactiveColor: GameColors.main,
                            thumbColor: GameColors.main,
                            label: controller.answerTime.value.toString(),
                            onChanged: (value) {
                              controller.answerTime.value = value;
                            },
                          ),
                          VerticalSpace(value: 0.5),
                          // ✅ إدخال اسم الفريق الأول
                          CustomTextFieldFormForUserName(
                            formKey: controller.teamOneKey,
                            myController: controller.teamOneController,
                            focusBorderColor: GameColors.white,
                            borderColor: GameColors.third,
                            hintText: "اسم الفريق الأول",
                            textAlign: TextAlign.center,
                            style: TextTheme.of(context).titleSmall!.copyWith(
                                  color: GameColors.white,
                                ),
                            width: SizeConfig.screenWidth! * 0.2,
                            height: SizeConfig.screenHeight! * 0.06,
                            hintStyle: TextTheme.of(context)
                                .titleSmall!
                                .copyWith(color: GameColors.white),
                          ),

                          VerticalSpace(value: 0.5), // مسافة بين الحقلين

                          // ✅ إدخال اسم الفريق الثاني
                          CustomTextFieldFormForUserName(
                            formKey: controller.teamTwoKey,
                            myController: controller.teamTwoController,
                            focusBorderColor: GameColors.white,
                            borderColor: GameColors.fourth,
                            hintText: "اسم الفريق الثاني",
                            textAlign: TextAlign.center,
                            style: TextTheme.of(context).titleSmall!.copyWith(
                                  color: GameColors.white,
                                ),
                            width: SizeConfig.screenWidth! * 0.2,
                            height: SizeConfig.screenHeight! * 0.06,
                            hintStyle: TextTheme.of(context)
                                .titleSmall!
                                .copyWith(color: GameColors.white),
                          ),
                          VerticalSpace(value: 1),
                          CustomHomeElevatedButton(
                            onTap: () {
                              if (Get.isRegistered<GameControllerImpl>()) {
                                Get.delete<GameControllerImpl>();
                              }
                              controller.teamOneName.value =
                                  controller.teamOneController.text;
                              controller.teamTwoName.value =
                                  controller.teamTwoController.text;
                              List<String> selectedCategories = controller
                                  .selectedCategories.entries
                                  .where((entry) => entry.value)
                                  .map((entry) => entry.key)
                                  .toList();

                              // ✅ إعادة إنشاء `GameControllerImpl` بتمرير الفئات المختارة
                              Get.put(GameControllerImpl(
                                selectedCategories: selectedCategories,
                                teamOneName: controller.teamOneController.text,
                                teamTwoName: controller.teamTwoController.text,
                                answerTime: controller.answerTime.value,
                              ));

                              Get.toNamed(GameRoutes.game);
                            },
                            circleRadius: 10,
                            text: "ابدأ اللعبة",
                            mainColor: GameColors.third,
                            secondColor: GameColors.white,
                            relativisticWidth: 0.2,
                            relativisticHeight: 0.07,
                            icon: Icons.play_circle_outline_rounded,
                            textStyle: TextTheme.of(context).titleSmall!,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )));
  }
}
