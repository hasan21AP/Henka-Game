import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/views/widgets/question_body.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GameColors.main,
        foregroundColor: GameColors.second,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GameColors.second,
          ),
          onPressed: () {
            Get.delete();
            Get.back();
          },
        ),
      ),
      body: const QuestionBody(),
    );
  }
}
