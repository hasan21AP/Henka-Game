import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:henka_game/core/constants/colors.dart';
import 'package:henka_game/core/customs/size_config.dart';
import 'package:henka_game/core/services/my_services.dart';
import 'package:henka_game/core/utils/binding.dart';
import 'package:henka_game/routes.dart';
import 'package:henka_game/views/screens/splash_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await initalServeces();
  runApp(const HenkaGame());
}

MyServices myServices = Get.find();

class HenkaGame extends StatelessWidget {
  const HenkaGame({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Henka Game',
      initialBinding: MyBinding(),
      initialRoute: '/',
      getPages: routes,
      theme: ThemeData(
          scaffoldBackgroundColor: GameColors.main,
          textTheme: TextTheme(
              titleLarge: TextStyle(
                  color: GameColors.second,
                  fontSize: SizeConfig.screenHeight! * 0.1,
                  fontFamily: 'Abd ElRady',
                  fontWeight: FontWeight.w800))),
      textDirection: TextDirection.rtl,
      home: const SplahsView(),
    );
  }
}
