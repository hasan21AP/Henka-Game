import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:henka_game/core/constants/images.dart';
import 'package:henka_game/views/screens/home_view.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: GameImages.logo,
      nextScreen: HomeView(),
      backgroundColor: Colors.transparent,
      splashIconSize: 300,
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
