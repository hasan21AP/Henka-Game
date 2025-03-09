import 'package:flutter/material.dart';
import 'package:henka_game/core/constants/colors.dart';

class CustomTextFieldFormForUserName extends StatelessWidget {
  const CustomTextFieldFormForUserName(
      {super.key,
      required this.focusBorderColor,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.borderColor,
      this.iconFocusColor,
      this.width,
      this.initialValue,
      required this.textAlign,
      required this.fontSize,
      this.hintStyle});

  final Color? focusBorderColor;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconFocusColor;
  final TextAlign textAlign;
  final double? width;
  final String? initialValue;
  final double fontSize;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.05,
            color: GameColors.main,
          ),
        ),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.name,
            autocorrect: true,
            initialValue: initialValue,
            validator: validator,
            textAlign: textAlign,
            cursorColor: focusBorderColor,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              hintText: hintText,
              hintStyle: hintStyle,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor!, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: focusBorderColor!,
                width: 2,
              )),
            ),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldFormForEmail extends StatelessWidget {
  const CustomTextFieldFormForEmail(
      {super.key,
      this.text,
      required this.focusBorderColor,
      this.icon,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.iconColor,
      this.borderColor,
      this.iconFocusColor,
      this.width,
      this.initialValue,
      this.textAlign});

  final String? text;
  final Color? focusBorderColor;
  final Widget? icon;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? iconFocusColor;
  final double? width;
  final String? initialValue;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.05,
            color: GameColors.main,
          ),
        ),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: true,
            validator: validator,
            cursorColor: focusBorderColor,
            initialValue: initialValue,
            textAlign: textAlign!,
            decoration: InputDecoration(
              prefixIcon: icon,
              // prefixIconColor: MaterialStateColor.resolveWith((states) =>
              // states.contains(MaterialState.focused)
              //   ? iconFocusColor!
              //   : iconColor!),
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              labelText: text,
              hintText: hintText,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor!, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: focusBorderColor!,
                width: 2,
              )),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldFormForPassword extends StatelessWidget {
  const CustomTextFieldFormForPassword(
      {super.key,
      required this.focusBorderColor,
      this.focusColor,
      this.obscureText,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.borderColor,
      this.iconFocusColor,
      this.textAlign,
      this.width});

  final Color? focusBorderColor;
  final Color? focusColor;
  final bool? obscureText;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconFocusColor;
  final TextAlign? textAlign;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.05,
            color: GameColors.main,
          ),
        ),
        child: Form(
          key: formKey,
          child: TextFormField(
              controller: myController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: obscureText!,
              autocorrect: false,
              validator: validator,
              cursorColor: focusBorderColor,
              textAlign: textAlign!,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                hintText: hintText,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor!, width: 2)),
                // floatingLabelStyle: TextStyle(
                //   color: focusColor,
                // ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: focusBorderColor!, width: 2)),
              ),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: textColor,
                  )),
        ),
      ),
    );
  }
}

class CustomLineContainer extends StatelessWidget {
  const CustomLineContainer({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: color,
          shape: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: .3, strokeAlign: BorderSide.strokeAlignCenter),
          )),
    );
  }
}

class CustomMultiLineForm extends StatelessWidget {
  const CustomMultiLineForm(
      {super.key,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.iconFocusColor,
      this.textAlign,
      this.maxLines,
      this.hintStyle,
      this.width,
      this.height,
      this.minLines,
      this.cursorColor});

  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? iconFocusColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? minLines;
  final TextStyle? hintStyle;
  final double? width;
  final double? height;
  final Color? cursorColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: GameColors.main,
          ),
        ),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.name,
            autocorrect: true,
            enabled: false,
            validator: validator,
            textAlign: textAlign!,
            readOnly: true,
            maxLines: maxLines,
            minLines: minLines,
            cursorColor: cursorColor,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              hintText: hintText,
              hintStyle: hintStyle,
            ),
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldFormForNumbers extends StatelessWidget {
  const CustomTextFieldFormForNumbers(
      {super.key,
      required this.focusBorderColor,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.borderColor,
      this.iconFocusColor,
      this.textAlign,
      this.width});

  final Color? focusBorderColor;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconFocusColor;
  final TextAlign? textAlign;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: myController,
          keyboardType: TextInputType.number,
          validator: validator,
          textAlign: textAlign!,
          cursorColor: focusBorderColor,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor!, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: focusBorderColor!,
              width: 2,
            )),
          ),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }
}

class CustomTextFieldFormForPhone extends StatelessWidget {
  const CustomTextFieldFormForPhone(
      {super.key,
      required this.focusBorderColor,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.borderColor,
      this.iconFocusColor,
      this.textAlign,
      this.width,
      this.initialValue});

  final Color? focusBorderColor;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconFocusColor;
  final TextAlign? textAlign;
  final double? width;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.05,
            color: GameColors.main,
          ),
        ),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.phone,
            validator: validator,
            textAlign: textAlign!,
            initialValue: initialValue,
            cursorColor: focusBorderColor,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor!, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: focusBorderColor!,
                width: 2,
              )),
            ),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: textColor,
                ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldFormForNotes extends StatelessWidget {
  const CustomTextFieldFormForNotes(
      {super.key,
      required this.focusBorderColor,
      this.onPressed,
      this.validator,
      this.formKey,
      this.myController,
      this.hintText,
      this.textColor,
      this.borderColor,
      this.iconFocusColor,
      this.textAlign,
      this.width,
      this.maxLines,
      this.minLines,
      this.fontSize});

  final Color? focusBorderColor;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final Key? formKey;
  final TextEditingController? myController;
  final String? hintText;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconFocusColor;
  final TextAlign? textAlign;
  final double? width;
  final int? maxLines;
  final int? minLines;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: myController,
          keyboardType: TextInputType.text,
          autocorrect: true,
          validator: validator,
          textAlign: textAlign!,
          maxLines: maxLines,
          cursorColor: focusBorderColor,
          minLines: minLines,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor!, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: focusBorderColor!,
              width: 2,
            )),
          ),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: textColor,
                fontSize: fontSize,
              ),
        ),
      ),
    );
  }
}
