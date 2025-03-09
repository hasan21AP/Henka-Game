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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: Text(
            "اختيار الفئات",
            style: TextTheme.of(context)
                .titleMedium!
                .copyWith(color: GameColors.main),
          ),
          backgroundColor: GameColors.second,
          foregroundColor: GameColors.white,
          pinned: true, // يجعل الـ AppBar ثابتة عند التمرير
          floating: false,
          snap: false,
          expandedHeight: SizeConfig.screenHeight! *
              0.1, // ارتفاع الـ AppBar عند عدم التمرير
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: GameColors.second),
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.01),
        child: Obx(() => controller.categories.length < 7
            ? Center(
                child: CircularProgressIndicator(
                color: GameColors.second,
              ))
            : ListView(
                children: [
                  Text(
                    "عدد الفئات التي تريدها:",
                    style: TextTheme.of(context).titleLarge!.copyWith(
                          color: GameColors.fourth,
                          fontSize: SizeConfig.screenWidth! * 0.02,
                        ),
                  ),
                  DropdownButton<int>(
                    value: controller.numberOfCategoryCount.value,
                    items: List.generate(
                      controller.categories.length, // الحد الأقصى لعدد الفئات
                      (index) => DropdownMenuItem(
                        value: index + 1, // عدد الفئات يبدأ من 1
                        child: Text("${index + 1}"),
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
                          color: GameColors.fourth,
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
                          controller.numberOfCategorySelected.value = controller
                              .selectedCategories.values
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
                              backgroundColor: GameColors.third,
                              colorText: GameColors.white,
                              duration: Duration(seconds: 2),
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
                              color: controller.selectedCategories[category] ==
                                          true &&
                                      controller
                                              .numberOfCategorySelected.value <=
                                          controller.numberOfCategoryCount.value
                                  ? GameColors.second
                                  : GameColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: GameColors.second,
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
                                    color: GameColors.second,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(9),
                                      topRight: Radius.circular(9),
                                    ),
                                  ),
                                  child: Text(
                                    nameEnToAr(category),
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth! * 0.02,
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
                            color: GameColors.fourth,
                            fontSize: SizeConfig.screenWidth! * 0.02,
                          )),
                  Slider(
                    value: controller.answerTime.value,
                    min: 60,
                    max: 300,
                    divisions: 4,
                    activeColor: GameColors.second,
                    inactiveColor: GameColors.third,
                    thumbColor: GameColors.second,
                    label: controller.answerTime.value.toString(),
                    onChanged: (value) {
                      controller.answerTime.value = value;
                    },
                  ),
                  VerticalSpace(value: 1),
                  // ✅ إدخال اسم الفريق الأول
                  CustomTextFieldFormForUserName(
                    formKey: controller.teamOneKey,
                    myController: controller.teamOneController,
                    focusBorderColor: GameColors.second,
                    borderColor: GameColors.second,
                    hintText: "اسم الفريق الأول",
                    textAlign: TextAlign.center,
                    fontSize: SizeConfig.screenWidth! * 0.02,
                    width: SizeConfig.screenWidth! * 0.4,
                  ),

                  VerticalSpace(value: 1), // مسافة بين الحقلين

                  // ✅ إدخال اسم الفريق الثاني
                  CustomTextFieldFormForUserName(
                    formKey: controller.teamTwoKey,
                    myController: controller.teamTwoController,
                    focusBorderColor: GameColors.second,
                    borderColor: GameColors.second,
                    hintText: "اسم الفريق الثاني",
                    textAlign: TextAlign.center,
                    fontSize: SizeConfig.screenWidth! * 0.02,
                  ),
                  VerticalSpace(value: 1),
                  CustomElevetedButton(
                    onPressed: () {
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
                    mainColor: GameColors.second,
                    secondColor: GameColors.white,
                    relativisticWidth: 0.8,
                    relativisticHeight: 0.07,
                  )
                ],
              )),
      ),
    );
  }
}
