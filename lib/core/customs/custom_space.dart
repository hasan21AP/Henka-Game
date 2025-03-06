import 'package:flutter/material.dart';
import 'package:henka_game/core/customs/size_config.dart';

class HorizanintalSpace extends StatelessWidget {
  const HorizanintalSpace({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: SizeConfig.defaultSize! * value!);
  }
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: SizeConfig.defaultSize! * value!);
  }
}
