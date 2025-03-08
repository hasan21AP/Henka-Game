import 'package:flutter/material.dart';
import 'package:henka_game/core/constants/colors.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: GameColors.second,
        backgroundColor: GameColors.main,
      ),
    );
  }
}
