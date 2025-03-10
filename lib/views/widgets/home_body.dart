import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/controller/home_controller.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/constants/images.dart';
import 'package:henka_game/core/customs/custom_buttons.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';

class HomeBody extends GetWidget<HomeControllerImpl> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImpl>(builder: (controller) {
      return Column(
        children: [
          const VerticalSpace(value: 2),
          Center(
              child: Image.asset(
            GameImages.logo,
            width: SizeConfig.screenWidth! * 0.2,
            height: SizeConfig.screenHeight! * 0.2,
            scale: 0.5,
          )),
          Center(
            child: Text(
              'اختبر حنكتك',
              style: TextTheme.of(context)
                  .titleLarge!
                  .copyWith(fontFamily: 'VIP Arabic Typo'),
            ),
          ),
          Center(
            child: Text(
              'وتحدى اصدقائك',
              style: TextTheme.of(context).titleLarge!.copyWith(
                    fontFamily: 'VIP Arabic Typo',
                  ),
            ),
          ),
          const VerticalSpace(value: 3),
          CustomHomeElevatedButton(
            text: 'ابدأ اللعب',
            onTap: () {
              controller.goToCategoryPage();
            },
            mainColor: GameColors.fourth,
            secondColor: GameColors.second,
            relativisticWidth: 0.3,
            relativisticHeight: .08,
            circleRadius: 10,
            icon: Icons.play_arrow_outlined,
            textStyle: TextTheme.of(context).titleSmall!,
          ),
          const VerticalSpace(value: 2),
          CustomHomeElevatedButton(
            text: 'الإعدادات',
            onTap: () {},
            mainColor: GameColors.fourth,
            secondColor: GameColors.second,
            relativisticWidth: 0.3,
            relativisticHeight: .08,
            circleRadius: 10,
            icon: Icons.settings_outlined,
            textStyle: TextTheme.of(context).titleSmall!,
          ),
        ],
      );
    });
  }
}
