import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/game_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';
import 'package:henka_game/core/functions/en_to_ar.dart';
import 'package:henka_game/views/screens/question_view.dart';

class GameBody extends GetView<GameControllerImpl> {
  const GameBody({
    required this.selectedCategories,
    required this.teamOneName,
    required this.teamTwoName,
    super.key,
  });

  final Map<String, bool> selectedCategories;
  final String teamOneName;
  final String teamTwoName;
  @override
  Widget build(BuildContext context) {
    List<String> categories = selectedCategories.keys.toList();
    // List<int> questionLevels =
    //     controller.questions.map((q) => q.points).toSet().toList()..sort();
    List<int> questionLevels = [100, 200, 300, 400, 500];
    // ✅ استخراج الفئات المختارة فقط
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ الشريط العلوي (الخروج - اسم اللعبة - زر البدء)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: GameColors.second),
                  onPressed: () {
                    Get.back(); // الرجوع للصفحة السابقة
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

            VerticalSpace(value: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories
                  .map(
                    (category) => Expanded(
                      child: Container(
                        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.01),
                        margin: EdgeInsets.all(SizeConfig.screenWidth! * 0.002),
                        decoration: BoxDecoration(
                          color: GameColors.second,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          nameEnToAr(category),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GameColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            VerticalSpace(value: 1),

            // ✅ الشبكة الرئيسية (الفئات والأسئلة)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double itemHeight = (constraints.maxHeight - 50) /
                      (questionLevels.isNotEmpty ? questionLevels.length : 1);
                  double itemWidth = (constraints.maxWidth - 20) /
                      (categories.isNotEmpty ? categories.length : 1);
// ✅ تصغير البطاقات

                  return GridView.builder(
                    shrinkWrap: true, // ✅ لمنع التمرير
                    physics: NeverScrollableScrollPhysics(), // ✅ تعطيل التمرير
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          categories.length, // عدد الأعمدة حسب الفئات المختارة
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: (itemWidth / itemHeight)
                          .clamp(0.5, 2.0), // ✅ ضبط الحجم تلقائيًا
                    ),
                    itemCount: categories.length * questionLevels.length,
                    itemBuilder: (context, index) {
                      int categoryIndex = index % categories.length;
                      int levelIndex = index ~/ categories.length;
                      String category = categories[categoryIndex];
                      int questionValue = questionLevels[levelIndex];

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => QuestionView(
                                category: category,
                                value: questionValue,
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: GameColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: GameColors.second, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              questionValue.toString(),
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
                },
              ),
            ),

            VerticalSpace(value: 1),

            // ✅ لوحة النقاط للفريقين
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreBoard(teamOneName, controller.teamOneScore),
                _buildScoreBoard(teamTwoName, controller.teamTwoScore),
              ],
            ),
          ],
        ));
  }

  // ✅ مكون لوحة النقاط لكل فريق
  Widget _buildScoreBoard(String teamName, RxInt score) {
    return Column(
      children: [
        Text(
          teamName,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: GameColors.second),
        ),
        Row(
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
                      fontSize: 24,
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
    );
  }
}
