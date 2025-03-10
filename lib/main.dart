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
import 'package:window_manager/window_manager.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Window Manager
  await windowManager.ensureInitialized();

  // ✅ ضبط النافذة لتكون Full Screen
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setFullScreen(false);
  });
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
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: GameColors.second,
            fontSize: SizeConfig.screenHeight! * 0.1,
            fontFamily: 'Cairo-Reqular',
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(
            color: GameColors.second,
            fontSize: SizeConfig.screenHeight! * 0.05,
            fontFamily: 'Cairo-Reqular',
            fontWeight: FontWeight.w800,
          ),
          titleSmall: TextStyle(
            color: GameColors.second,
            fontSize: SizeConfig.screenHeight! * 0.025,
            fontFamily: 'Cairo-Reqular',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      textDirection: TextDirection.rtl,

      // ✅ إضافة الخلفية المتدرجة لكل الشاشات افتراضيًا
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                GameColors.main,
                GameColors.third,
                GameColors.fourth
              ], // الألوان من الأزرق إلى الفيروزي
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: child, // تمرير محتوى التطبيق داخل الخلفية
        );
      },

      home: const SplahsView(),
    );
  }
}
