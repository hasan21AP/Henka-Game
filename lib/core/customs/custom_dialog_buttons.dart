import 'package:flutter/material.dart';
import 'package:henka_game/core/customs/custom_buttons.dart';
import 'package:henka_game/core/customs/size_config.dart';

class CustomDialogButton extends StatelessWidget {
  const CustomDialogButton(
      {super.key,
      this.text,
      this.onTap,
      this.backgroundColor,
      this.textColor,
      this.width,
      this.height,
      this.circleRadius,
      this.textStyle});

  final String? text;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? circleRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return CustomGeneralButton(
      text: text,
      onTap: onTap,
      backgroundColor: backgroundColor,
      textColor: textColor,
      width: SizeConfig.screenWidth! * 0.06,
      height: SizeConfig.screenHeight! * 0.06,
      circleRadius: 8,
      textStyle: textStyle,
    );
  }
}
