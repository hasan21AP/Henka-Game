import 'package:flutter/material.dart';
import 'package:henka_game/core/audio/audio_services.dart';
import 'package:henka_game/core/customs/custom_space.dart';
import 'package:henka_game/core/customs/size_config.dart';

class CustomGeneralButton extends StatelessWidget {
  const CustomGeneralButton(
      {super.key,
      this.text,
      this.onTap,
      this.backgroundColor,
      this.textColor,
      this.width,
      this.height = 60,
      this.circleRadius = 15,
      this.textStyle});

  final String? text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? circleRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(circleRadius!),
          ),
          child: Center(
            child: Text(text!, textAlign: TextAlign.center, style: textStyle),
          ),
        ));
  }
}

class CustomElevetedButton extends StatelessWidget {
  const CustomElevetedButton(
      {super.key,
      this.text,
      this.onPressed,
      this.mainColor,
      this.secondColor,
      this.relativisticWidth,
      this.relativisticHeight,
      this.circleRadius,
      this.textStyle});

  final String? text;
  final VoidCallback? onPressed;
  final Color? mainColor;
  final Color? secondColor;
  final double? relativisticWidth;
  final double? relativisticHeight;
  final double? circleRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AudioService.playClickSound();
        onPressed!();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: secondColor,
          minimumSize: Size(SizeConfig.screenWidth! * relativisticWidth!,
              SizeConfig.screenHeight! * relativisticHeight!),
          enableFeedback: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circleRadius!),
          ),
          textStyle: textStyle),
      child: Text(text!),
    );
  }
}

class CustomSignInButton extends StatelessWidget {
  const CustomSignInButton(
      {super.key,
      this.text,
      this.onPressed,
      this.mainColor,
      this.secondColor,
      this.iconData,
      this.iconColor,
      this.iconSize,
      this.horizontalPadding,
      this.relativisticWidth,
      this.relativisticHeight,
      this.circleRadius,
      this.textStyle,
      this.borderWidth,
      this.borderColor,
      this.elevation});

  final String? text;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final Color? mainColor;
  final Color? secondColor;
  final Color? iconColor;
  final double? iconSize;
  final double? horizontalPadding;
  final double? relativisticWidth;
  final double? relativisticHeight;
  final double? circleRadius;
  final TextStyle? textStyle;
  final double? borderWidth;
  final Color? borderColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: secondColor,
          elevation: elevation,
          minimumSize: Size(SizeConfig.screenWidth! * relativisticWidth!,
              SizeConfig.screenHeight! * relativisticHeight!),
          enableFeedback: false,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: borderWidth!,
              color: borderColor!,
            ),
            borderRadius: BorderRadius.circular(circleRadius!),
          ),
          textStyle: textStyle,
        ),
        child: SizedBox(
          width: SizeConfig.screenWidth! * 0.84,
          height: SizeConfig.screenHeight! * 0.07,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
            const HorizanintalSpace(value: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding!),
              child: Text(
                text!,
              ),
            ),
          ]),
        ));
  }
}

class CustomHomeElevatedButton extends StatelessWidget {
  const CustomHomeElevatedButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    required this.mainColor,
    required this.secondColor,
    required this.relativisticWidth,
    required this.relativisticHeight,
    required this.circleRadius,
    required this.textStyle,
  });

  final String text;
  final void Function()? onTap;
  final IconData icon;
  final Color mainColor;
  final Color secondColor;
  final double relativisticWidth;
  final double relativisticHeight;
  final double circleRadius;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AudioService.playClickSound();
        onTap!();
      },
      child: Container(
        width: SizeConfig.screenWidth! * relativisticWidth,
        height: SizeConfig.screenHeight! * relativisticHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circleRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            // ✅ الجزء الأول (النص داخل الزر الداكن)
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(circleRadius),
                    bottomLeft: Radius.circular(circleRadius),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: textStyle.copyWith(color: Colors.white),
                ),
              ),
            ),

            // ✅ الجزء الثاني (الأيقونة داخل الزر الفاتح)
            Container(
              width: SizeConfig.screenWidth! * 0.10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(circleRadius),
                  bottomRight: Radius.circular(circleRadius),
                ),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              alignment: Alignment.center,
              padding:
                  EdgeInsets.symmetric(horizontal: 20), // ✅ ضبط التباعد الداخلي
              child: Icon(
                icon,
                color: mainColor,
                size: SizeConfig.screenWidth! * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.mainColor,
    required this.secondColor,
    required this.relativisticWidth,
    required this.relativisticHeight,
    required this.circleRadius,
    required this.textStyle,
  });

  final String text;
  final void Function()? onTap;
  final Color mainColor;
  final Color secondColor;
  final double relativisticWidth;
  final double relativisticHeight;
  final double circleRadius;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AudioService.playClickSound();
        onTap!();
      },
      child: Container(
        width: SizeConfig.screenWidth! * relativisticWidth,
        height: SizeConfig.screenHeight! * relativisticHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circleRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            // ✅ الجزء الأول (النص داخل الزر الداكن)
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(circleRadius),
                    bottomLeft: Radius.circular(circleRadius),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: textStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton(
      {super.key,
      required this.onTap,
      required this.image,
      required this.width,
      required this.height});

  final void Function() onTap;
  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await AudioService.playClickSound();
          onTap();
        },
        child: Image.asset(
          image,
          width: SizeConfig.screenWidth! * width,
          height: SizeConfig.screenHeight! * height,
        ));
  }
}
