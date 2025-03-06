import 'package:get/get.dart';
import 'package:henka_game/core/constants/routes.dart';
import 'package:henka_game/core/middleware/my_middleware.dart';
import 'package:henka_game/views/screens/category_view.dart';
import 'package:henka_game/views/screens/home_view.dart';
import 'package:henka_game/views/screens/splash_view.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
      name: GameRoutes.splash,
      page: () => const SplahsView(),
      middlewares: [MyMiddleware()]),
  GetPage(
    name: GameRoutes.home,
    page: () => const HomeView(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GameRoutes.category,
    page: () => const CategoryView(),
    transition: Transition.native,
  ),
  // GetPage(
  //   name: GameRoutes.game,
  //   page: () => const GameView(),
  //   transition: Transition.native,
  // ),
];
