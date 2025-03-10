import 'package:flutter/material.dart';
import 'package:henka_game/views/widgets/question_body.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const QuestionBody(),
    );
  }
}
