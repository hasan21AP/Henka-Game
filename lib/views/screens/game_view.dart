import 'package:flutter/material.dart';
import 'package:henka_game/views/widgets/game_body.dart';

class GameView extends StatelessWidget {
  const GameView(
      {super.key,
      required this.teamOneName,
      required this.teamTwoName,
      required this.selectedCategories});

  final Map<String, bool> selectedCategories;
  final String teamOneName;
  final String teamTwoName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GameBody(
      selectedCategories: selectedCategories,
      teamOneName: teamOneName,
      teamTwoName: teamTwoName,
    ));
  }
}
