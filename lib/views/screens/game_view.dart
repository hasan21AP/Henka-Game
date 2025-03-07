import 'package:flutter/material.dart';
import 'package:henka_game/views/widgets/game_body.dart';

class GameView extends StatelessWidget {
  const GameView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const GameBody());
  }
}
