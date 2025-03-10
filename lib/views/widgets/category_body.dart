import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/category_controller.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
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
    return Padding(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.01),
        child: Obx(() => controller.categories.length < 7
            ? Center(
                child: CircularProgressIndicator(
                color: GameColors.second,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "عدد الفئات التي تريدها:",
                      style: TextTheme.of(context).titleLarge!.copyWith(
                            fontSize: SizeConfig.screenWidth! * 0.02,
                          ),
                    ),
                    DropdownButton<int>(
                      value: controller.numberOfCategoryCount.value,
                      dropdownColor: GameColors.fourth,
                      menuWidth: SizeConfig.screenWidth! * 0.1,
                      items: List.generate(
                        controller.categories.length, // الحد الأقصى لعدد الفئات
                        (index) => DropdownMenuItem(
                          value: index + 1, // عدد الفئات يبدأ من 1
                          child: Text("${index + 1}",
                              style: TextTheme.of(context).titleSmall),
                        ),
                      ),
                      onChanged: (value) {
                        controller.numberOfCategoryCount.value = value!;
                        controller.selectedCategories
                            .updateAll((key, value) => false);
                      },
                    ),
                    Text(
                      "اختر الفئات التي تريدها:",
                      style: TextTheme.of(context).titleLarge!.copyWith(
                            fontSize: SizeConfig.screenWidth! * 0.02,
                          ),
                    ),
                    VerticalSpace(value: 2),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // منع التمرير داخل GridView لأنه داخل ListView
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            7, // عدد الأعمدة (يمكنك تغييره إلى 3 لجعل البطاقات أصغر)
                        crossAxisSpacing: 8, // تقليل المسافات بين الأعمدة
                        mainAxisSpacing: 8, // تقليل المسافات بين الصفوف
                        childAspectRatio:
                            0.8, // تقليل نسبة العرض إلى الارتفاع لتصغير البطاقات
                      ),
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        String category = controller.categories[index];
                        bool isSelected =
                            controller.selectedCategories[category] ?? false;
                        return GestureDetector(
                          onTap: () {
                            controller.numberOfCategorySelected.value =
                                controller.selectedCategories.values
                                    .where((value) => value)
                                    .length;
                            if (!isSelected &&
                                controller.numberOfCategorySelected.value >=
                                    controller.numberOfCategoryCount.value) {
                              // منع التحديد الزائد وإظهار رسالة تنبيه
                              Get.snackbar(
                                "تنبيه",
                                "لا يمكنك اختيار أكثر من ${controller.numberOfCategoryCount.value} فئات",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: GameColors.fourth,
                                colorText: GameColors.white,
                                duration: Duration(seconds: 4),
                              );
                            } else {
                              // تغيير حالة الفئة (تحديد/إلغاء تحديد)
                              controller.selectedCategories[category] =
                                  !isSelected;
                            }
                          },
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color:
                                    controller.selectedCategories[category] ==
                                                true &&
                                            controller.numberOfCategorySelected
                                                    .value <=
                                                controller
                                                    .numberOfCategoryCount.value
                                        ? GameColors.fourth
                                        : GameColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: GameColors.third,
                                  width: 3,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // شريط علوي يحتوي على اسم الفئة
                                  Container(
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: GameColors.fourth,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(9),
                                        topRight: Radius.circular(9),
                                      ),
                                    ),
                                    child: Text(
                                      nameEnToAr(category),
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.screenWidth! * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // الصورة داخل البطاقة
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          controller.images[index],
                                          fit: BoxFit
                                              .fill, // يجعل الصورة واضحة بدون قص
                                          width: double.infinity,
                                        ),
                                      ),
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
                              color: GameColors.white,
                              fontSize: SizeConfig.screenWidth! * 0.02,
                            )),
                    Slider(
                      value: controller.answerTime.value,
                      min: 60,
                      max: 300,
                      divisions: 4,
                      activeColor: GameColors.fourth,
                      inactiveColor: GameColors.white,
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
                      focusBorderColor: GameColors.third,
                      borderColor: GameColors.third,
                      hintText: "اسم الفريق الأول",
                      textAlign: TextAlign.center,
                      style: TextTheme.of(context).titleSmall!.copyWith(
                            color: GameColors.fourth,
                          ),
                      width: SizeConfig.screenWidth! * 0.2,
                      height: SizeConfig.screenHeight! * 0.06,
                      hintStyle: TextTheme.of(context)
                          .titleSmall!
                          .copyWith(color: GameColors.fourth),
                    ),

                    VerticalSpace(value: 0.5), // مسافة بين الحقلين

                    // ✅ إدخال اسم الفريق الثاني
                    CustomTextFieldFormForUserName(
                      formKey: controller.teamTwoKey,
                      myController: controller.teamTwoController,
                      focusBorderColor: GameColors.fourth,
                      borderColor: GameColors.fourth,
                      hintText: "اسم الفريق الثاني",
                      textAlign: TextAlign.center,
                      style: TextTheme.of(context).titleSmall!.copyWith(
                            color: GameColors.fourth,
                          ),
                      width: SizeConfig.screenWidth! * 0.2,
                      height: SizeConfig.screenHeight! * 0.06,
                      hintStyle: TextTheme.of(context)
                          .titleSmall!
                          .copyWith(color: GameColors.fourth),
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
                      mainColor: GameColors.fourth,
                      secondColor: GameColors.white,
                      relativisticWidth: 0.3,
                      relativisticHeight: 0.07,
                      icon: Icons.play_circle_outline_rounded,
                      textStyle: TextTheme.of(context).titleSmall!,
                    )
                  ],
                ),
              )));
  }
}
